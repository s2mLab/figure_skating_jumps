import csv, click
import pandas as pd
import numpy as np
from analysis import make_data_abs

@click.command()
@click.argument("source", type=click.File('r'))
@click.argument("target", type=click.File('w'))
def trim_csv(source, target):
    """Trims empty columns.

    Args:\n
        source (str): Path to file to read from.\n
        target (str): Path to file to write to.
    """
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

@click.command()
@click.argument("source", type=click.File('r'))
@click.argument("target", type=str)
def make_absolute(source, target):
    """Converts data to absolute referential.

    Args:\n
        source (str): Path to file to read from.\n
        target (str): Path to file to write to.
    """
    data: pd.DataFrame = pd.read_csv(
        source,
        header=0,
        names=('counter', 'time', 'euler_x', 'euler_y', 'euler_z', 'acc_x', 'acc_y', 'acc_z', 'gyr_x', 'gyr_y', 'gyr_z')
    )
    
    abs_data = make_data_abs(data)
        
    with open(target, "w", newline="") as write_file:
        writer = csv.writer(write_file)
        writer.writerow(["iter", "acc_x", "acc_y", "acc_z", "gyr_x", "gyr_y", "gyr_z"])
        for row in abs_data.iloc:
            writer.writerow(row.to_list())

@click.command()
@click.argument("source", type=click.File('r'))
@click.argument("target", type=str)
@click.argument("make_abs", type=bool)
def format_csv(source: str, target: str, make_abs: bool = False):
    """Trims and converts to absolute referential.

    Args:\n
        source (str): Path to file to read from.\n
        target (str): Path to file to write to.\n
        make_abs (bool, optional): If true will convert to the absolute
        referential otherwise it won't. Defaults to False.
    """
    trim_csv(source, target)
    if make_abs:
        make_absolute(target, target)

@click.group()
def format():
    """Run --help with the command name to get more information"""
    pass

format.add_command(format_csv)
format.add_command(trim_csv)
format.add_command(make_absolute)

if __name__ == "__main__":
    format()
