import csv
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import pandas as pd
from scipy.spatial.transform import Rotation as R
import numpy as np
import time
from math import sin, cos, radians
from dataclasses import dataclass
from enum import Enum

# Referential while XSens faces you and is right way up
# X goes up
# Y goes left
# Z goes towards you

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
    

def format_csv(source, target):
    with open(source, 'r') as read_file:
        data = []
        reader = csv.reader(read_file)
        for row in reader:
            data.append(row)
        
        valid_columns = 0
        for iter, row in enumerate(data):
            if "PacketCounter" in row:
                valid_columns = len([iter for iter in row if len(iter) > 0])
                data = data[iter:]
                break

        with open(target, "w", newline="") as write_file:
            writer = csv.writer(write_file)
            for row in data:
                writer.writerow(row[:valid_columns])

def rotate_matrix(vector, matrix, degrees=True):
    rot = R.from_rotvec(vector, degrees=degrees)
    return rot.apply(matrix, inverse=True)

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
        
        # print(row['time'], row['euler_x'], row['euler_y'], row['euler_z'], row['acc_x'], row['acc_y'], row['acc_z'], row['gyr_x'], row['gyr_y'], row['gyr_z'])
        # print(iter)
        # print(row['acc_x'], row['acc_y'], row['acc_z'])
        # print(row['euler_x'], row['euler_y'], row['euler_z'])
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

def find_jumps_bad(name):
    data = pd.read_csv(
        name,
        header=0,
        names=('counter', 'time', 'euler_x', 'euler_y', 'euler_z', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )

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
        
        # print(row['time'], row['euler_x'], row['euler_y'], row['euler_z'], row['acc_x'], row['acc_y'], row['acc_z'], row['gyr_x'], row['gyr_y'], row['gyr_z'])
        # print(iter)
        # print(row['acc_x'], row['acc_y'], row['acc_z'])
        # print(row['euler_x'], row['euler_y'], row['euler_z'])
        acc = np.array([row['acc_x'], row['acc_y'], row['acc_z']])
        acc = acc - noise # noise removal
        acc = np.matmul(rot_mat, acc)
        acc = np.array([round(acc[0], 1), round(acc[1], 1), round(acc[2], 1)])
        print(acc)

def get_rotation_matrix(x_deg, y_deg, z_deg):
    x = radians(x_deg)
    y = radians(y_deg)
    z = radians(z_deg)
    rot_z = np.array([[cos(z), -sin(z), 0], [sin(z), cos(z), 0], [0, 0, 1]])
    rot_y = np.array([[cos(y), 0, sin(y)], [0, 1, 0], [-sin(y), 0, cos(y)]])
    rot_x = np.array([[1, 0, 0], [0, cos(x), -sin(x)], [0, sin(x), cos(x)]])
    return np.matmul(np.matmul(rot_z, rot_y), rot_x)

def find_jumps_official(name):
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

def analyze_jump(jump):
    pass

start = time.time()
# format_csv("./recordings/David_Down.csv", "./david_up.csv")
# trajectory = find_trajectory("./face_up.csv")
# find_jumps("first")
jumps = find_jumps_official("./charlotte.csv")
# find_jumps("./spin.csv")
print(f"Finished in {time.time() - start} seconds.")
# show_graph(trajectory)
