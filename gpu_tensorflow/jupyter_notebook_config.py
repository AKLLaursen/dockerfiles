# Configuration file for jupyter-notebook.

## The IP address the notebook server will listen on.
c.NotebookApp.ip = '0.0.0.0'

## Whether to open in a browser after starting. The specific browser used is
#  platform dependent and determined by the python standard library `webbrowser`
#  module, unless it is overridden using the --browser (NotebookApp.browser)
#  configuration option.
c.NotebookApp.open_browser = False

## Hashed password to use for web authentication.
#  
#  To generate, type in a python/IPython shell:
#  
#    from notebook.auth import passwd; passwd()
#  
#  The string should be of the form type:salt:hashed-password.
c.NotebookApp.password = 'sha1:e8eb003db720:b25aa1c872be1c081b3b1d010abc2e6e240c2033'

## The port the notebook server will listen on.
c.NotebookApp.port = 8888

