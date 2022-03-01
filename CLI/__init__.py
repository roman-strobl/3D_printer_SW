import sys

import click

from .printer_commands import printer_commands

@click.group(
    name="print3D",
    invoke_without_command=True,
    cls=click.CommandCollection,
    sources=[printer_commands,
             ],
)
@click.pass_context
def main_cli(ctx, **kwargs):
    pass