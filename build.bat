@echo off
python -m nuitka ^
    --standalone ^
    --enable-plugin=tk-inter ^
    --nofollow-import-to=tkinter ^
    --output-dir=build ^
    --remove-output ^
    main.py