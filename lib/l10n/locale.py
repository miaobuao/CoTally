import meo
from watchdog.observers import Observer
from watchdog.events import *
import time
import re
import yaml

class FileEventHandler(FileSystemEventHandler):
    def __init__(self):
        FileSystemEventHandler.__init__(self)

    def on_created(self, event):
        if event.is_directory:
            print("directory created:{0}".format(event.src_path))
        else:
            updateLocaleFile(event.src_path)
            print("file created:{0}".format(event.src_path))

    def on_modified(self, event):
        if event.is_directory:
            print("directory modified:{0}".format(event.src_path))
        else:
            updateLocaleFile(event.src_path)
            print("file modified:{0}".format(event.src_path))


def updateLocaleFile(yml_path: str):
    path, filename = os.path.split(yml_path)
    if res := re.search(r"locale_([a-z]+).yaml", filename):
        locale = res.group(1).lower()
    else:
        return None
    arb_path = os.path.join(path, f"intl_{locale}.arb")
    try:
        with open(yml_path, 'r', encoding='utf8') as f:
            data = yaml.load(f, Loader=yaml.FullLoader)
        meo.to_json(data, arb_path)
    except Exception as e:
        print(e)
    

if __name__ == "__main__":
    observer = Observer()
    event_handler = FileEventHandler()
    observer.schedule(event_handler, meo.utils.script_path(__file__), True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
