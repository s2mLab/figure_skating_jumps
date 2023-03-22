import pandas as pd
import numpy as np
import time

from math import sin, cos, radians, sqrt

# Referential while XSens faces you and is right way up
# X goes up
# Y goes left
# Z goes towards you

def read_csv(source) -> pd.DataFrame:
    data: pd.DataFrame = pd.read_csv(
        source,
        header=0,
        names=('counter', 'time', 'euler_x', 'euler_y', 'euler_z', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )
    return data

def make_data_abs(data: pd.DataFrame) -> pd.DataFrame:
    abs_data = []
    for iter, row in data.iterrows():
        # Apply referential rotation to work with new axes
        rot_mat = get_rotation_matrix(row['euler_x'], row['euler_y'], row['euler_z'])
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        acc = np.matmul(rot_mat, acc)
        gyr = np.array([row['gyr_x'], row['gyr_y'], row['gyr_z']])
        gyr = np.matmul(rot_mat, gyr)
        
        abs_data.append([iter, acc[0], acc[1], acc[2], gyr[0], gyr[1], gyr[2]])
    return pd.DataFrame(abs_data, columns=['iter', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z'])

def get_rotation_matrix(x_deg, y_deg, z_deg) -> np.ndarray:
    x = radians(x_deg)
    y = radians(y_deg)
    z = radians(z_deg)
    rot_z = np.array([[cos(z), -sin(z), 0], [sin(z), cos(z), 0], [0, 0, 1]])
    rot_y = np.array([[cos(y), 0, sin(y)], [0, 1, 0], [-sin(y), 0, cos(y)]])
    rot_x = np.array([[1, 0, 0], [0, cos(x), -sin(x)], [0, sin(x), cos(x)]])
    return np.matmul(np.matmul(rot_z, rot_y), rot_x)

def find_jumps(data: pd.DataFrame) -> "list[pd.DataFrame]":
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

def analyze_session(source):
    # Read from the csv
    data: pd.DataFrame = read_csv(source)
    jumps = find_jumps(data)

def analyze_jump(jump_data: pd.DataFrame):
    max_rot_speed = 0 # return in a struct
    time_to_max = 0 # return in a struct
    rot_speed = 0
    for _, row in jump_data.iterrows():
        rot_vec = np.array([row['gyr_x'], row['gyr_y'], row['gyr_z']])
        rot_speed = sqrt(sum(rot_vec**2))
        if rot_speed > max_rot_speed:
            max_rot_speed = rot_speed
            time_to_max = row['iter']
    
    time_to_max -= jump_data.iloc[0]['iter']
    
    print(time_to_max * 8333 / (10 ** 6), max_rot_speed)

def find_num_rot(jump_data: pd.DataFrame, DELTA_T = 8333):
    return sum([sqrt(sum(np.array([row['gyr_x'],row['gyr_y'],row['gyr_z']])**2)) * (DELTA_T / 10**6) for _, row in jump_data.iterrows()])

def caller(source):
    data = make_data_abs(read_csv(source))
    print(find_num_rot(data.iloc[2089:2193]))

start = time.time()
# caller("anthony/abs_01.csv", 2975, 3013)
caller("anthony/any_04.csv")
# trajectory = find_trajectory("./face_up.csv")
# find_jumps("first")
# jumps = find_jumps_official("./anthony/any_01.csv")
# print(jumps)
# jumps = find_jumps_experimental("./anthony/any_02.csv")
# print(jumps)
# find_jumps("./spin.csv")
print(f"Finished in {time.time() - start} seconds.")
# show_graph(trajectory)
