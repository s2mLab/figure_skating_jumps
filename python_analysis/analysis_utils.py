import pandas as pd
import numpy as np
import csv

from ice_exceptions import InvalidFormatError

from math import sin, cos, radians

def write_csv_from_dataframe(data: pd.DataFrame, target: str) -> None:
    """Writes a dataframe out into a csv with the header row.

    Args:
        data (pd.DataFrame): The dataframe containing the data.
        target (str): The name of the file to write to. It will create one if needed.
    """
    with open(target, "w", newline="") as write_file:
        writer = csv.writer(write_file)
        writer.writerow(list(data.columns))
        for _, row in data.iterrows():
            writer.writerow(row)

def read_raw_csv_to_dataframe(source: str) -> pd.DataFrame:
    """Reads the raw output of a XSensDot into a dataframe.\n
    It can still read a csv as long as the headers have not been changed.

    Args:
        source (str): Path to file to read from.
    """

    header_converter = {
        'PacketCounter': 'iter',
        'SampleTimeFine': 'time',
        'Euler_X': 'euler_x',
        'Euler_Y': 'euler_y',
        'Euler_Z': 'euler_z',
        'Acc_X': 'acc_x',
        'Acc_Y': 'acc_y',
        'Acc_Z': 'acc_z',
        'Gyr_X': 'gyr_x',
        'Gyr_Y': 'gyr_y',
        'Gyr_Z': 'gyr_z'
    }

    raw_data = []
    with open(source, 'r') as read_file:
        reader = csv.reader(read_file)
        for row in reader:
            raw_data.append(row)
    
    valid_columns = 0
    headers = []
    for iter, row in enumerate(raw_data):
        if "PacketCounter" in row:
            valid_columns = len([iter for iter in row if len(str(iter).strip()) > 0])
            headers = raw_data[iter][:valid_columns]
            raw_data = raw_data[iter + 1:]
            break
    headers = [header_converter.get(str(iter).strip()) for iter in headers]
    
    if len(headers) != len(header_converter.keys()) or all([iter in headers for iter in header_converter.keys()]):
        raise InvalidFormatError
    
    for iter, row in enumerate(raw_data):
        raw_data[iter] = [float(iter) for iter in row[:valid_columns]]
    
    return pd.DataFrame(raw_data, columns=headers)

def get_rotation_matrix(x_deg: float, y_deg: float, z_deg: float) -> np.ndarray:
    """Returns the ZYX rotation matrix to go from the local referential
    to the absolute one.

    Args:
        x_deg (float): Rotation in degrees around the x axis
        y_deg (float): Rotation in degrees around the y axis
        z_deg (float): Rotation in degrees around the z axis

    Returns:
        np.ndarray: The 3x3 matrix which can be used to convert
        a vector to the absolute referential.
    """
    x = radians(x_deg)
    y = radians(y_deg)
    z = radians(z_deg)
    rot_z = np.array([[cos(z), -sin(z), 0], [sin(z), cos(z), 0], [0, 0, 1]])
    rot_y = np.array([[cos(y), 0, sin(y)], [0, 1, 0], [-sin(y), 0, cos(y)]])
    rot_x = np.array([[1, 0, 0], [0, cos(x), -sin(x)], [0, sin(x), cos(x)]])
    return np.matmul(np.matmul(rot_z, rot_y), rot_x)

def make_data_abs(data: pd.DataFrame) -> pd.DataFrame:
    """Convers the dataframe to the absolute referential.
    It removes some columns that are no longer needed.

    Args:
        data (pd.DataFrame)

    Returns:
        pd.DataFrame
    """
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
