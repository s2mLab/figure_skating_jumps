import pandas as pd
import numpy as np
import analysis_utils
import click

from ice_exceptions import EmptyFileError

from enum import Enum
from math import sqrt
from os.path import exists


# Referential while XSens faces you and is right way up
# X goes up
# Y goes left
# Z goes towards you


SEC_TO_MS_RATIO = 10**6 # conversion from microseconds to seconds
MAX_NOISE = 3.5 # meters per second squared
MIN_FREE_FALL_TIME = 0.2 * SEC_TO_MS_RATIO # 0.3 seconds in microseconds
MAX_INTERRUPTION = 0.05 * SEC_TO_MS_RATIO # 0.03 seconds in microseconds
MIN_ROTATION_SPEED = 480 # degrees per second
MIN_IMPULSE = 20 # meters per second squared

class Jump:
    start: int
    end: int
    
    def __init__(self, start: int, end: int) -> None:
        self.start = start
        self.end = end
    
class Jump_Analysis:
    start: int
    end: int
    duration: float
    rot_deg: float
    max_rot_speed: float
    time_to_max: float
    
    def __init__(self, start, end, num_rot, max_rot_speed, time_to_max) -> None:
        self.start = start
        self.end = end
        self.duration = end - start
        self.rot_deg = num_rot
        self.max_rot_speed = max_rot_speed
        self.time_to_max = time_to_max
    
    def toMap(self) -> map:
        return {
            "start": self.start,
            "end": self.end,
            "duration": self.duration,
            "numRot": self.rot_deg,
            "maxRotSpeed": self.max_rot_speed,
            "timeToMax": self.time_to_max
        }
    
class State(Enum):
    SKATING = 0
    DETECTING = 1
    FALLING = 2

def find_jumps_from_vertical_acc(data: pd.DataFrame) -> 'list[Jump]':
    """Uses the vertical acceleration of each frame to determine if it is a jump or not.
    It looks for a period of time where the vertical acceleration is close to zero.
    It allows small interruptions during which the vertical acceleration can go 
    up/down without disqualifying the jump.

    Args:
        data (pd.DataFrame)

    Returns:
        list[Jump]
    """
    jumps: list[Jump] = []
    state: State = State.SKATING
    jump_start: int = 0
    falling_ticks: int = 0
    interruption_ticks: int = 0
    # Find the jumps
    for iter, row in data.iterrows():
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        free_falling = abs(acc[2]) < MAX_NOISE
        
        if (state == State.SKATING):
            # If we detect a fall, pass to Detecting and increase counter
            if free_falling:
                falling_ticks += 1
                jump_start = iter
                state = State.DETECTING
                
        elif (state == State.DETECTING):
            # Increase the counters to see if we detect a fall or if it was fake
            if free_falling:
                falling_ticks += 1
                interruption_ticks = 0
            else:
                interruption_ticks += 1
            
            # Make a decision if one of the counters reached a critical point
            if interruption_ticks * DELTA_T >= MAX_INTERRUPTION:
                falling_ticks = 0
                interruption_ticks = 0
                state = State.SKATING
            elif falling_ticks * DELTA_T >= MIN_FREE_FALL_TIME:
                state = State.FALLING
                
        elif (state == State.FALLING):
            if free_falling:
                falling_ticks += 1
                interruption_ticks = 0
            else:
                interruption_ticks += 1
                
            if interruption_ticks * DELTA_T >= MAX_INTERRUPTION:
                jumps.append(Jump(jump_start, iter))
                falling_ticks = 0
                interruption_ticks = 0
                state = State.SKATING
    
    return jumps

def find_jumps_from_rotation_speed(data: pd.DataFrame) -> 'list[Jump]':
    """Uses the rotation speed of each frame to determine if it is a jump or not.
    It looks for a period of time where the norm of the rotation speed vector is high enough.
    It allows small interruptions during which the speed can go back down without 
    disqualifying the jump. It also needs at least one moment during which it detects a freefall
    for it to count as a jump.

    Args:
        data (pd.DataFrame)

    Returns:
        list[Jump]
    """
    jumps: list[Jump] = []
    state: State = State.SKATING
    jump_start: int = 0
    spinning_ticks: int = 0
    interruption_ticks: int = 0
    free_falling = False
    
    for iter, row in data.iterrows():
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        gyr = np.array([row['gyr_x'], row['gyr_y'], row['gyr_z']])
        spinning = np.linalg.norm(gyr) >= MIN_ROTATION_SPEED
        
        if (state == State.SKATING):
            # If we detect a spin, pass to Detecting and increase counter
            if spinning:
                spinning_ticks += 1
                jump_start = iter
                state = State.DETECTING
        elif (state == State.DETECTING):
            # Increase the counters to see if we detect a fall or if it was fake
            if spinning:
                free_falling = abs(acc[2]) < MAX_NOISE or free_falling
                spinning_ticks += 1
                interruption_ticks = 0
            else:
                interruption_ticks += 1
            
            # Make a decision if one of the counters reached a critical point
            if interruption_ticks * DELTA_T >= MAX_INTERRUPTION:
                spinning_ticks = 0
                interruption_ticks = 0
                free_falling = False
                state = State.SKATING
            elif spinning_ticks * DELTA_T >= MIN_FREE_FALL_TIME and free_falling:
                state = State.FALLING
        elif (state == State.FALLING):
            if spinning:
                spinning_ticks += 1
                interruption_ticks = 0
            else:
                interruption_ticks += 1
            
            if interruption_ticks * DELTA_T >= MAX_INTERRUPTION:
                jumps.append(Jump(jump_start, iter))
                spinning_ticks = 0
                interruption_ticks = 0
                free_falling = False
                state = State.SKATING
    
    return jumps

def find_jumps_from_horizontal_acc(data: pd.DataFrame) -> 'list[Jump]':
    """Uses the horizontal acceleration of each frame to determine if it is a jump or not.
    It looks for a period of time where the norm of the horizontal acceleration vector is high enough.
    It allows small interruptions during which the acceleration can go back down without 
    disqualifying the jump. It also needs at least one moment during which it detects a freefall
    for it to count as a jump.

    Args:
        data (pd.DataFrame)

    Returns:
        list[Jump]
    """
    jumps: list[Jump] = []
    state: State = State.SKATING
    jump_start: int = 0
    impulse_ticks: int = 0
    interruption_ticks: int = 0
    free_falling = False
    
    for iter, row in data.iterrows():
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        acc_xy = np.linalg.norm(acc[:1])
        is_impulse_moment = acc_xy >= MIN_ROTATION_SPEED
        
        if (state == State.SKATING):
            # If we detect a spin, pass to Detecting and increase counter
            if is_impulse_moment:
                impulse_ticks += 1
                jump_start = iter
                state = State.DETECTING
        elif (state == State.DETECTING):
            # Increase the counters to see if we detect a fall or if it was fake
            if is_impulse_moment:
                free_falling = abs(acc[2]) < MAX_NOISE or free_falling
                impulse_ticks += 1
                interruption_ticks = 0
            else:
                interruption_ticks += 1
            
            # Make a decision if one of the counters reached a critical point
            if interruption_ticks * DELTA_T >= MAX_INTERRUPTION:
                impulse_ticks = 0
                interruption_ticks = 0
                free_falling = False
                state = State.SKATING
            elif impulse_ticks * DELTA_T >= MIN_FREE_FALL_TIME and free_falling:
                state = State.FALLING
        elif (state == State.FALLING):
            if is_impulse_moment:
                impulse_ticks += 1
                interruption_ticks = 0
            else:
                interruption_ticks += 1
            
            if interruption_ticks * DELTA_T >= MAX_INTERRUPTION:
                jumps.append(Jump(jump_start, iter))
                impulse_ticks = 0
                interruption_ticks = 0
                free_falling = False
                state = State.SKATING
    
    return jumps

def find_jumps(data: pd.DataFrame) -> 'list[Jump]':
    """Finds the jumps in the given dataset. It uses three metrics to do so:
    vertical acceleration, horizontal acceleration and rotation speed.
    It then merges the results into one array that it returns.

    Args:
        data (pd.DataFrame)

    Returns:
        list[Jump]: A list of jumps, containing their start and end frame.
    """
    # Find all jumps
    jumps: list[Jump] = find_jumps_from_vertical_acc(data)
    jumps.extend(find_jumps_from_rotation_speed(data))
    jumps.extend(find_jumps_from_horizontal_acc(data))
    
    # Sort them to allow for a merge
    jumps.sort(key=lambda jump: (jump.start))
    
    # Merges jumps that are overlapping to avoid a single wrong value ruining the result
    index_to_remove = []
    for i in range(len(jumps) - 1):
        if jumps[i].end >= jumps[i + 1].start:
            jumps[i].end = jumps[i + 1].end
            index_to_remove.append(i+1)
    
    # Flips the array so we can remove redundant jumps without affecting the other indexes
    for iter in reversed(index_to_remove):
        del jumps[iter]
    
    return jumps

def find_num_rot(jump_data: pd.DataFrame) -> float:
    """Finds the number of rotations from a jump's data.

    Args:
        jump_data (pd.DataFrame)

    Returns:
        float: The number of rotations done in degrees.
    """
    return sum([
        np.linalg.norm(np.array([row['gyr_x'],row['gyr_y'],row['gyr_z']]))
        for _, row in jump_data.iterrows()
    ]) * (DELTA_T / SEC_TO_MS_RATIO)

def analyze_jump(jump: Jump, jump_data: pd.DataFrame) -> Jump_Analysis:
    """Analyzes a single jump using the jump and the data set.

    Args:
        jump (Jump)
        jump_data (pd.DataFrame): The data of the current jump only. Not the whole data set.

    Returns:
        Jump_Analysis
    """
    num_rot = find_num_rot(jump_data)
    start = jump.start * (DELTA_T / SEC_TO_MS_RATIO)
    end = jump.end * (DELTA_T / SEC_TO_MS_RATIO)
    max_rot_speed = 0
    time_to_max = 0
    rot_speed = 0
    for _, row in jump_data.iterrows():
        rot_vec = np.array([row['gyr_x'], row['gyr_y'], row['gyr_z']])
        rot_speed = sqrt(sum(rot_vec**2))
        if rot_speed > max_rot_speed:
            max_rot_speed = rot_speed
            time_to_max = row['iter']
    
    time_to_max -= jump_data.iloc[0]['iter']
    time_to_max *= (DELTA_T / SEC_TO_MS_RATIO)
    return Jump_Analysis(start, end, num_rot, max_rot_speed, time_to_max)

def analyze_session(source: str) -> 'list[Jump_Analysis]':
    """Reads a raw XSensDot output file and analyzes it.

    Args:
        source (str): The path to the file to read from.

    Raises:
        FileNotFoundError

    Returns:
        list[Jump_Analysis]: A list of all jump analysis.
    """
    # Read from the csv
    if not exists(source):
        raise FileNotFoundError()
    data: pd.DataFrame = analysis_utils.read_raw_csv_to_dataframe(source)
    
    if data.size == 0:
        raise EmptyFileError
    
    # Assign DELTA_T as soon as we can
    global DELTA_T
    DELTA_T = data.iloc[1]['time'] - data.iloc[0]['time']
    
    # Make data absolute and analyze it
    data = analysis_utils.make_data_abs(data)
    jumps: list[Jump] = find_jumps(data)
    jump_analysis: list[Jump_Analysis] = []
    for j in jumps:
        jump_analysis.append(analyze_jump(j, data.iloc[j.start:j.end+1]))
    
    return jump_analysis

@click.command()
@click.argument("source", type=str)
def analyze_session_cmd(source: str) -> 'list[Jump_Analysis]':
    """Reads a raw XSensDot output file and analyzes it.\n
    This is the command version and should not be called from code, only from a terminal.

    Args:
        source (str): The path to the file to read from.

    Raises:
        FileNotFoundError

    Returns:
        list[Jump_Analysis]: A list of all jump analysis.
    """
    return analyze_session(source)

if __name__ == "__main__":
    analyze_session_cmd()
