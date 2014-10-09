#!/usr/bin/env python2
import gtk
import sys
from tempfile import NamedTemporaryFile
from subprocess import call

count = 0
f = NamedTemporaryFile(suffix='.png')


def handle_owner_change(clipboard, event):
    global count
    #print 'clipboard.owner-change(%r, %r)' % (clipboard, event)
    count += 1
    if count > 1:
        #call(["rm", filename])
        f.close()
        sys.exit(0)


call(["scrot", "-s", f.name])
image = gtk.gdk.pixbuf_new_from_file(f.name)
clipboard = gtk.clipboard_get()
clipboard.connect('owner-change', handle_owner_change)
clipboard.set_image(image)
clipboard.store()
gtk.main()
