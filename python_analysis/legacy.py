import pandas as pd
import numpy as np
import matplotlib as plt

from enum import Enum
from dataclasses import dataclass
from math import sin, cos, radians
from analysis import get_rotation_matrix

#region Trajectory attempt

def find_trajectory(name):
    data = pd.read_csv(
        name,
        header=0,
        names=('counter', 'time', 'euler_x', 'euler_y', 'euler_z', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )

    speed = np.array([0,0,0])
    trajectory = [[0,0,0]]
    gravity = 9.81
    old_time = data.iloc[0]['time']
    noise = np.array([data.iloc[1]['acc_x'], data.iloc[1]['acc_y'], data.iloc[1]['acc_z']])

    for iter, row in data.iterrows():
        if iter == 0:
            continue
        # Apply referential rotation to work with new axes
        x = radians(row['euler_x'])
        y = radians(row['euler_y'])
        z = radians(row['euler_z'])
        rot_z = np.array([[cos(z), -sin(z), 0], [sin(z), cos(z), 0], [0, 0, 1]])
        rot_y = np.array([[cos(y), 0, sin(y)], [0, 1, 0], [-sin(y), 0, cos(y)]])
        rot_x = np.array([[1, 0, 0], [0, cos(x), -sin(x)], [0, sin(x), cos(x)]])
        rot_mat = np.matmul(np.matmul(rot_z, rot_y), rot_x)
        
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        # acc = acc - noise # noise removal
        acc = np.matmul(rot_mat, acc)
        # acc = np.array([round(acc[0], 1), round(acc[1], 1), round(acc[2], 1)])
        print(acc)
        # in micro seconds
        delta = (row['time'] - old_time) / 10**6
        position = (acc * delta**2 / 2 + speed * delta + np.array(trajectory[-1])).tolist()
        trajectory.append(position)
        speed = acc * delta + speed
        old_time = row['time']
    
    return trajectory

def show_graph(trajectory):
    trajectory = np.array(trajectory)

    # Initialize a 3D plot
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')

    # Plot the points
    ax.plot(trajectory[:, 0:1], trajectory[:, 1:2], trajectory[:, 2:3], '-o')

    # Label the axes
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

    plt.show()

#endregion

#region Jump detection state machine

@dataclass
class Jump:
    start: int = 0
    end: int = 0
    first_tick: int = 0
    tick_duration: int = 0

class State(Enum):
    SKATING = 1
    JUMPING = 2
    FALLING = 3
    LANDING = 4

def find_jumps_v1(name):
    data: pd.DataFrame = pd.read_csv(
        name,
        header=0,
        names=('counter', 'time', 'euler_x', 'euler_y', 'euler_z', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )
    
    G_VAL: float = 9.81
    DELTA_T: int = data.iloc[1]['time'] - data.iloc[0]['time']
    MIN_STABLE_TIME: int = 0.1 * 10**6 # 0.1 seconds in microseconds
    MAX_IMPULSE_DURATION: int = 1 * 10**6 # 0.5 seconds in microseconds
    MAX_JUMP_TIME: int = 2 * 10**6 # 2 seconds in microseconds
    MAX_NOISE: int = 2
    MIN_IMPULSE_STRENGTH: int = 15
    
    state: State = State.SKATING
    jumps: list[Jump] = []
    current_jump = Jump()
    stable_tick = 0
    for iter, row in data.iterrows():
        # Apply referential rotation to work with new axes
        rot_mat = get_rotation_matrix(row['euler_x'], row['euler_y'], row['euler_z'])
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        acc = np.matmul(rot_mat, acc)
        z_acc = acc[2]
        
        if state == State.JUMPING: # If you jumped, check for gravity fall
            if abs(z_acc) < MAX_NOISE or (z_acc < 0 and z_acc > -5):
                stable_tick += 1
            
            if stable_tick * DELTA_T >= MIN_STABLE_TIME:
                state = State.FALLING
                stable_tick = 0
            elif row['time'] - current_jump.start >= MAX_IMPULSE_DURATION:
                state = State.SKATING
                stable_tick = 0
        elif state == State.FALLING:
            if z_acc > MIN_IMPULSE_STRENGTH: # TODO Maybe add a second clause on magnitude of impulse
                state = State.LANDING
            if row['time'] - current_jump.start >= MAX_JUMP_TIME:
                state = State.SKATING
        elif state == State.LANDING:
            if abs(z_acc - G_VAL) < MAX_NOISE:
                stable_tick += 1
            
            if stable_tick * DELTA_T >= MIN_STABLE_TIME:
                state = State.SKATING
                current_jump.end = row['time']
                current_jump.tick_duration = iter - current_jump.first_tick
                jumps.append(Jump(current_jump.start, current_jump.end, current_jump.first_tick, current_jump.tick_duration))
                stable_tick = 0
            elif row['time'] - current_jump.start >= MAX_JUMP_TIME:
                state = State.SKATING
                stable_tick = 0
        elif z_acc > MIN_IMPULSE_STRENGTH:
            state = State.JUMPING
            current_jump.start = row['time']
            current_jump.first_tick = iter
            
    return jumps
    
    # with open('test.csv', "w", newline="") as write_file:
    #     writer = csv.writer(write_file)
    #     writer.writerow(["iter", "x", "y", "z"])
    #     for row in tester:
    #         writer.writerow(row)

#endregion

#region Zero detection attempt

def find_jumps_v2(name):
    # Read from the csv
    data: pd.DataFrame = pd.read_csv(
        name,
        header=0,
        names=('counter', 'time', 'euler_x', 'euler_y', 'euler_z', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )
    
    # Define constants for the math
    DELTA_T: int = data.iloc[1]['time'] - data.iloc[0]['time']
    MIN_FREE_FALL_TIME: int = 0.3 * 10**6 # 0.3 seconds in microseconds
    MAX_NOISE: int = 3
    WINDOW_TIME: int = 0.2 * 10**6 # 0.2 seconds in microseconds
    WINDOW_TICK: int = WINDOW_TIME // DELTA_T # window time in ticks
    detection_ticks = 0
    fall_ticks = 0
    jumps = []
    
    # Find the jumps
    for iter, row in data.iterrows():
        rot_mat = get_rotation_matrix(row['euler_x'], row['euler_y'], row['euler_z'])
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        acc = np.matmul(rot_mat, acc)
        is_noise = abs(acc[2]) < MAX_NOISE
        
        # Increase length of detection zone
        if is_noise:
            detection_ticks += 1
        else:
            detection_ticks = 0
        
        # If it has found a fall, keeps counting until it finds no more
        if fall_ticks > 0:
            if is_noise:
                fall_ticks += 1
            else:
                jumps.append({'start': int(iter - fall_ticks - WINDOW_TICK), 'end': int(iter + WINDOW_TICK)})
                fall_ticks = 0
        # If there is no fall, it will start one
        elif detection_ticks * DELTA_T >= MIN_FREE_FALL_TIME:
            fall_ticks = detection_ticks
    
    # Merges jumps that are very close to avoid a single wrong value ruining the result
    index_to_remove = []
    for i in range(len(jumps) - 1):
        if jumps[i]['end'] >= jumps[i + 1]['start']:
            jumps[i]['end'] = jumps[i + 1]['end']
            index_to_remove.append(i+1)
    
    # Flips the array so we can remove without affecting the other indexes
    index_to_remove.reverse()
    for iter in index_to_remove:
        del jumps[iter]
    
    return jumps

#endregion
