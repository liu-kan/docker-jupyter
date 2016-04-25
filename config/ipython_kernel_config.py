c = get_config()
# ... Any other configurables you want to set
c.IPKernelApp.matplotlib = 'inline'
c.InlineBackend.rc = {
    'font.size': 11,
    'font.family': 'FandolSong',
    'axes.unicode_minus': False,
    'figure.figsize': (6.0, 4.0),
    'savefig.dpi': 80,
    'axes.unicode_minus': False,
    'axes.titlesize': 12
}

c.InlineBackend.figure_formats = set(['png', 'retina'])
