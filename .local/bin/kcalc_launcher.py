#!/usr/bin/env python3

import subprocess

from dbus_next.service import ServiceInterface, method
from dbus_next.aio.message_bus import MessageBus
from dbus_next.errors import DBusError

import asyncio


class KCalcLauncher(ServiceInterface):
    @method()
    def Launch(self) -> "s":
        try:
            subprocess.Popen(["kcalc"])
            return "Launched kcalc"
        except Exception as e:
            raise DBusError("org.user.KCalcLauncher.Error", str(e))


async def main():
    bus = await MessageBus().connect()
    bus.export("/org/user/KCalcLauncher", KCalcLauncher("org.user.KCalcLauncher"))
    await bus.request_name("org.user.KCalcLauncher")
    await asyncio.get_event_loop().create_future()


asyncio.get_event_loop().run_until_complete(main())
