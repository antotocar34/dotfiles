import subprocess


def open_editor(filename):

    config_file = "/home/carneca/.config/kitty/ink.conf"
    extra_command = "let g:ink_on=1 | let b:airline_disable_statusline = 1"

    subprocess.run([
        'kitty',
        '--config', config_file,
        '--name', 'popup-bottom-center',
        '-e', "nvim",
        '--cmd', extra_command,
        "-u", "~/.config/nvim/init.vim",
        f"{filename}",
    ])
    # subprocess.run([
    #     'urxvt',
    #     '-fn', 'xft:Iosevka Term:pixelsize=24',
    #     '-geometry', '60x5',
    #     '-name', 'popup-bottom-center',
    #     "-fg", "white",
    #     "-bg", "black",
    #     '-e', "nvim",
    #     '--cmd', extra_command,
    #     "-u", "~/.config/nvim/init.vim",
    #     f"{filename}",
    # ])


def latex_document(latex):
    return r"""
        \documentclass[12pt,border=12pt]{standalone}
        \usepackage[utf8]{inputenc}
        \usepackage[T1]{fontenc}
        \usepackage{textcomp}
        \usepackage{amsmath, amssymb}
        %\usepackage{cmbright}
        \begin{document}
    """ + latex + r"\end{document}"

config = {
    'rofi_theme': '~/.config/rofi/nord.rasi',
    'font': 'Iosevka Term',
    'font_size': 10,
    'open_editor': open_editor,
    'latex_document': latex_document
}
