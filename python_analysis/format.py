import click
import pandas as pd
import analysis_utils

def format_csv(source: str, target: str, make_abs: bool = False) -> None:
    """Reads a raw XSensDot csv and trims the data. Can also convert it to the absolute referential.

    Args:\n
        source (str): Path to file to read from.\n
        target (str): Path to file to write to.\n
        make_abs (bool, optional): If true will convert to the absolute
        referential otherwise it won't. Defaults to False.
    """
    data: pd.DataFrame = analysis_utils.read_raw_csv_to_dataframe(source)
    if make_abs:
        data = analysis_utils.make_data_abs(data)
    analysis_utils.write_csv_from_dataframe(data, target)

@click.command()
@click.argument("source", type=str)
@click.argument("target", type=str)
@click.option("-a", "--make-abs", is_flag=True, default=False, help="Include this flag if you want the output to be absolute.")
def format_csv_cmd(source: str, target: str, make_abs: bool = False) -> None:
    """Reads a raw XSensDot csv and trims the data. Can also convert it to the absolute referential.\n
    This is the command version and should not be called from code, only from a terminal.

    Args:\n
        source (str): Path to file to read from.\n
        target (str): Path to file to write to.\n
        make_abs (bool, optional): If true will convert to the absolute
        referential otherwise it won't. Defaults to False.
    """
    format_csv(source, target, make_abs)

if __name__ == "__main__":
    format_csv_cmd()
