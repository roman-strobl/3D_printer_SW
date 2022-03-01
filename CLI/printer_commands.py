import click


@click.group()
def printer_commands():
	pass


@printer_commands.group(name="printer")
@click.pass_context
def printer(ctx):
	pass
