import click
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import analysis_utils

from math import sqrt

def read_abs_csv(source: str) -> pd.DataFrame:
    """Reads an absolute csv into a dataframe.

    Args:
        source (str): The path to the file to read from.

    Returns:
        pd.DataFrame: The dataframe containing all the data.
    """
    data: pd.DataFrame = pd.read_csv(
        source,
        header=0,
        names=('iter', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )
    return data

@click.command()
@click.argument("source", type=str)
@click.option("-a", "--is-abs", is_flag=True, default=False, help="Include this flag if csv is treated to be absolute.")
@click.option("-h", "--height", default=5, type=int, help="The height of the graph.")
@click.option("-w", "--width", default=10, type=int, help="The width of the graph.")
def show_treated_data(source: str, is_abs: bool = False, height: int = 5, width: int = 10) -> None:
    """Shows the three metrics used to find jumps.

    Args:
        source (str): The file to read from.\n
        is_abs (bool): Whether the csv is absolute.\n
        height (int): The height of the graph.\n
        width (int): The width of the graph.
    """
    # Reads the csv and loads it into a dataframe
    data: pd.DataFrame
    if is_abs:
        data = read_abs_csv(source)
    else:
        data = analysis_utils.make_data_abs(analysis_utils.read_raw_csv_to_dataframe(source))
    
    # Creates the figure as three superposed graphs sharing the x lines    
    fig = plt.figure()
    grid_spec = fig.add_gridspec(3, hspace=0)
    axis: list[plt.Axes] = grid_spec.subplots(sharex=True)
    
    # Adds the vertical acceleration graph
    axis[0].plot(data['iter'].to_list(), data['acc_z'].to_list())
    axis[0].set_ylabel('Vertical Acceleration')
    axis[0].axhline(y=0, color='k') # Helps to see when there is a free fall
    
    # Calculates and adds the horizontal acceleration graph
    acc_xy = [
        np.linalg.norm(np.array([row['acc_x'], row['acc_y']]))
        for _, row in data.iterrows()
    ]
    axis[1].plot(data['iter'].to_list(), acc_xy)
    axis[1].set_ylabel('Horizontal Acceleration')
    axis[1].set_ylim(bottom=0) # The values are never negative
    
    # Calculates and adds the rotation speed graph
    rot = [
        np.linalg.norm(np.array([row['gyr_x'], row['gyr_y'], row['gyr_z']]))
        for _, row in data.iterrows()
    ]
    axis[2].plot(data['iter'].to_list(), rot)
    axis[2].set_ylabel('Rotation Speed')
    axis[2].set_ylim(bottom=0) # The values are never negative
    
    # Prevents the x axis from going past the data on all graphs
    # Makes the increment smaller to make it more readable
    increment: int = 100
    max_x: int = data['iter'].to_list()[-1]
    for iter in axis:
        iter.set_xticks(np.arange(0, max_x, increment))
        iter.set_xlim(left=0, right=max_x)
        iter.grid(axis='x')
    plt.xticks(fontsize=8)
    
    # Makes the graph bigger on the screen
    fig.set_figwidth(width)
    fig.set_figheight(height)
    fig.tight_layout()
    plt.show()

if __name__ == "__main__":
    show_treated_data()