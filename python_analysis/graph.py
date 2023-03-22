import click
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

from math import sqrt
from analysis import read_csv

def read_abs_csv(source) -> pd.DataFrame:
    data: pd.DataFrame = pd.read_csv(
        source,
        header=0,
        names=('iter', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )
    return data

def add_acc_z(data: pd.DataFrame):
    plt.plot(data['iter'].to_list(), data[f'acc_z'].to_list())
    plt.title('Vertical Acceleration')

def add_acc_xy(data: pd.DataFrame):
    acc_xy = [
        sqrt(row['acc_x'] ** 2 + row['acc_y'] ** 2) 
        for iter, row in data.iterrows()
    ]
    plt.plot(data['iter'].to_list(), acc_xy)
    plt.title('Horizontal Acceleration')

def add_rot_speed(data: pd.DataFrame):
    rot = [
        sqrt(row['gyr_x'] ** 2 + row['gyr_y'] ** 2 + row['gyr_z'] ** 2)
        for iter, row in data.iterrows()
    ]
    plt.plot(data['iter'].to_list(), rot)
    plt.title('Rotation Speed')

def show_acc_z(source: str, is_abs: bool = True):
    data = read_abs_csv(source) if is_abs else read_csv(source)
    add_acc_z(data)
    plt.show()
    
def show_acc_xy(source: str, is_abs: bool = True):
    data = read_abs_csv(source) if is_abs else read_csv(source)
    add_acc_xy()
    plt.show()

def show_rot_speed(source: str, is_abs: bool = True):
    data = read_abs_csv(source) if is_abs else read_csv(source)
    add_rot_speed(data)
    plt.show()

@click.command()
@click.argument("source", type=click.File('r'))
@click.argument("is_abs", type=bool, required=False)
def show_all_data(source: str, is_abs: bool = True):
    """Shows the three metrics used to find jumps.

    Args:
        source (str): The file to read from.
        is_abs (bool, optional): Determines wether the file was treated
        to be absolute or not. Defaults to True.
    """
    data = read_abs_csv(source) if is_abs else read_csv(source)
    max_x = data['iter'].to_list()[-1]
    increment = 100
    fig = plt.figure()
    grid_spec = fig.add_gridspec(3, hspace=0)
    axis: list[plt.Axes] = grid_spec.subplots(sharex=True)
    
    axis[0].plot(data['iter'].to_list(), data[f'acc_z'].to_list())
    axis[0].set_ylabel('Vertical Acceleration')
    axis[0].axhline(y=0, color='k')
    
    acc_xy = [
        sqrt(row['acc_x'] ** 2 + row['acc_y'] ** 2) 
        for _, row in data.iterrows()
    ]
    axis[1].plot(data['iter'].to_list(), acc_xy)
    axis[1].set_ylabel('Horizontal Acceleration')
    axis[1].set_ylim(bottom=0)
    
    rot = [
        sqrt(row['gyr_x'] ** 2 + row['gyr_y'] ** 2 + row['gyr_z'] ** 2)
        for _, row in data.iterrows()
    ]
    axis[2].plot(data['iter'].to_list(), rot)
    axis[2].set_ylabel('Rotation Speed')
    axis[2].set_ylim(bottom=0)
    
    for iter in axis:
        iter.set_xticks(np.arange(0, max_x, increment))
        iter.set_xlim(left=0, right=max_x)
        iter.grid(axis='x')
        
    plt.xticks(fontsize=8)
    fig.set_figwidth(16)
    fig.set_figheight(8)
    fig.tight_layout()
    plt.show()

@click.group()
def graph():
    """Run --help with the command name to get more information"""
    pass

graph.add_command(show_all_data)

if __name__ == "__main__":
    graph()