import os
import tempfile
import subprocess
import shutil
from flask import Flask, request, send_file, after_this_request
from werkzeug.datastructures import FileStorage

app = Flask(__name__)


@app.route('/build', methods=['POST'])
def build():
    app.logger.info("Building app...")

    home = os.getcwd()
    if 'file' not in request.files:
        return "no file in data", 500

    file = request.files['file']    # type: FileStorage
    if file.filename == '':
        return "no selected file", 500

    if not file.filename.endswith(".zip"):
        return "not a zip file", 500

    target = tempfile.mkdtemp()

    app.logger.info("Extracting zip file")
    zipfile = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    zipfile.close()
    file.save(zipfile.name)
    subprocess.run(["unzip", "-n", "-d", target, zipfile.name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    os.remove(zipfile.name)

    app.logger.info("Checking zip file")
    os.chdir(target)
    dir_count = 0
    file_count = 0
    root = None
    for f in os.listdir():
        if os.path.isdir(f):
            dir_count += 1
            root = f
        else:
            file_count += 1

    if dir_count == 0:
        shutil.rmtree(target)
        return "zip file has no root", 500
    elif dir_count > 1:
        shutil.rmtree(target)
        return "zip file has multiple roots", 500
    elif file_count > 0:
        return "zip file has files outside its root", 500

    app.logger.info("make clean")
    os.chdir(root)
    subprocess.run(["make", "clean"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    app.logger.info("make all")
    res = subprocess.run(["make", "all"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    f = open("OUT.txt", "wb")
    f.write(res.stdout)
    f.close()

    f = open("ERR.txt", "wb")
    f.write(res.stderr)
    f.close()

    f = open("RES.txt", "w")
    f.write("OK\n" if res.returncode == 0 else "FAILED /{0}\n".format(res.returncode))
    f.close()

    app.logger.info("zip result")
    os.chdir(target)

    res = subprocess.run(["zip", "-r", "-", root], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL)
    zipfile = tempfile.NamedTemporaryFile(suffix=".zip", delete=False)
    zipfile.write(res.stdout)
    zipfile.close()

    os.chdir(home)
    shutil.rmtree(target)

    @after_this_request
    def remove_file(response):
        app.logger.info("cleanup")
        try:
            os.remove(zipfile.name)
        except Exception as error:
            app.logger.error("Error removing file", error)
        return response

    app.logger.info("send result")
    return send_file(zipfile.name, "application/zip", True, "result.zip")

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=8080)
