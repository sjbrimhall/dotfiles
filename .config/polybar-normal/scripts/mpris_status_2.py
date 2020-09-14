#!/usr/bin/env python3

import time
import sys
import gi
import re
import os
import notify2 as Notify

label_error = "program error"
label_closed = "no player"
label_playing = "%title% by %artist%"
label_paused = "%title% by %artist%"

foreground_error = "#7e344f"
foreground_closed = "#3a5775"
foreground_playing = "-"
foreground_paused = "#3a5775"

title_maxlen = 30;
artist_maxlen = 30;

notify = os.environ['POLYBAR_MONITOR'] == "HDMI-1"

def color_text(text: str, color: str) -> str:
    return f"%{{F{color}}}{text}%{{F-}}"
    
try:
    gi.require_version('Playerctl', '2.0')
except:
    print(color_text(label_error, foreground_error))

from gi.repository import Playerctl, GLib

class Status:

    def __init__(self):
        self.running = False
        self.playing = False
        self.title = None
        self.artist = None
        self.album = None
        self.album_artist = None
        self.color = "-"

    def __str__(self):

        output = label_closed
        self.color = foreground_closed

        if self.running:
            output = label_playing.replace(
                "%title%",self.title).replace(
                "%artist%",self.artist).replace(
                "%album%",self.album)
            self.color = self.playing and foreground_playing or foreground_paused

        return output

    def polybar_print(self):
        return color_text(str(self), self.color)

class StatusDisplay:

    def __init__(self):
        self._player = None
        self._format = label_closed
        if notify:
            Notify.init('Music')

            self._notif = Notify.Notification("Now Playing")
            self._notif.set_urgency(0)
            self._notif.set_timeout(5000)

    def show(self):
        self._init_player()

        main = GLib.MainLoop()
        main.run()

    def _get_status(self, playing = None):
        if self._player:
            status = Status()
            status.running = self._player.props.playback_status != 2
            if playing is None:
                status.playing = self._player.props.playback_status == 0
            else:
                status.playing = playing
            status.title = self._player.get_title() or ""
            status.artist = self._player.get_artist() or ""
            status.album = self._player.get_album() or ""

            if len(status.title) > title_maxlen:
                status.title = status.title[:title_maxlen-1] + '…'
            if len(status.artist) > artist_maxlen:
                status.artist = status.artist[:artist_maxlen-1] + '…'

            return status
        else:
            return Status()

    def _print_status(self, status):
        print(status.polybar_print(), flush=True)

        if not notify:
            return

        if not status.running:
            return
        if not status.playing:
            self._notif.update("Paused", str(status))
            self._notif.show()
            return
        self._notif.update("Playing", str(status))
        self._notif.show()

    def _init_player(self):

        success = False
        
        while not success:
            try:
                self._player = Playerctl.Player()
                self._player.connect('metadata', self._on_update)
                self._player.connect('play', self._on_play)
                self._player.connect('pause', self._on_pause)
                self._player.connect('exit', self._on_exit)
                
                self._print_status(self._get_status())

                success = True
            except:
                
                self._print_status(Status())
                time.sleep(2)

    def _on_update(self, *args):
        self._print_status(self._get_status())

    def _on_play(self, *args):
        self._print_status(self._get_status(playing=True))

    def _on_pause(self, *args):
        self._print_status(self._get_status(playing=False))

    def _on_exit(self, player):
        del self._player
        self._player = None
        self._init_player()

StatusDisplay().show()
