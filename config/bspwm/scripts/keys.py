#!/usr/bin/env python3
"""Read sxhkdrc and turn it into a readable keybinding list.

  keys.py --rows       one line per binding, for the cheat sheet (super + F1)
  keys.py --cmd N      the command of row N, or nothing if it is not safe to run from the cheat sheet
  keys.py --keys N     the key combination of row N
  keys.py --markdown   Markdown tables, used to generate docs/KEYBINDINGS.md
  keys.py --check      exit 1 on duplicate key combinations or unexpanded braces

Each binding is described by the comment line directly above its key line. Section titles are the
text between two '####' banner lines. Brace groups such as {h,j,k,l} are expanded the same way sxhkd does.
"""
import itertools, os, re, sys

CONFIG = os.environ.get('SXHKDRC', os.path.expanduser('~/.config/sxhkd/sxhkdrc'))
GROUP = re.compile(r'\{([^{}]*)\}')
BANNER = re.compile(r'#{5,}')

NAMES = {
    'super': 'Super', 'alt': 'Alt', 'ctrl': 'Ctrl', 'shift': 'Shift',
    'Return': 'Enter', 'Escape': 'Esc', 'space': 'Space', 'Tab': 'Tab', 'Print': 'Print',
    'grave': '`', 'comma': ',', 'period': '.', 'bracketleft': '[', 'bracketright': ']',
    'Left': 'Left', 'Right': 'Right', 'Up': 'Up', 'Down': 'Down',
    'XF86AudioRaiseVolume': 'Volume Up', 'XF86AudioLowerVolume': 'Volume Down',
    'XF86AudioMute': 'Mute', 'XF86AudioMicMute': 'Mic Mute',
    'XF86MonBrightnessUp': 'Brightness Up', 'XF86MonBrightnessDown': 'Brightness Down',
    'XF86AudioPlay': 'Play/Pause', 'XF86AudioNext': 'Next Track', 'XF86AudioPrev': 'Previous Track',
}
# Commands that change the session. The cheat sheet shows them but will not run them on Enter.
UNSAFE = re.compile(r'bspc (quit|wm -r)|bspc node -[ck]\b|systemctl|pkill|reboot|poweroff|suspend|rm -')


def read_bindings(path):
    lines = open(path, encoding='utf-8').read().splitlines()
    out, section, desc, cur = [], 'General', '', None

    def finish():
        if cur is not None:
            out.append(dict(cur, cmd=' ; '.join(cur['cmd_lines'])))

    for i, raw in enumerate(lines):
        line = raw.rstrip()
        stripped = line.strip()
        if stripped.startswith('#'):
            if BANNER.fullmatch(stripped):
                continue
            body = stripped.strip('#').strip()
            prev_banner = i > 0 and BANNER.fullmatch(lines[i - 1].strip())
            next_banner = i + 1 < len(lines) and BANNER.fullmatch(lines[i + 1].strip())
            if prev_banner and next_banner:
                section = body.capitalize() if body.isupper() else body
            else:
                desc = body
            continue
        if not stripped:
            continue
        if raw[0] in ' \t':                       # command line of the current binding
            if cur is not None:
                cur['cmd_lines'].append(stripped.rstrip('\\').strip())
            continue
        finish()                                  # a key line starts a new binding
        cur = dict(section=section, desc=desc, keys=stripped.lstrip('@~'), cmd_lines=[])
        desc = ''
    finish()
    return out


def options(group):
    items = []
    for part in group.split(','):
        m = re.fullmatch(r'([0-9])-([0-9])', part)
        items += [str(n) for n in range(int(m.group(1)), int(m.group(2)) + 1)] if m else [part]
    return items


def substitute(text, groups, pick):
    counter = iter(range(len(groups)))
    return GROUP.sub(lambda m: '' if groups[(i := next(counter))][pick[i]] == '_' else groups[i][pick[i]], text)


def expand(keys, cmd):
    kg = [options(g) for g in GROUP.findall(keys)]
    cg = [options(g) for g in GROUP.findall(cmd)]
    if not kg and not cg:
        return [(keys, cmd)]
    if [len(g) for g in kg] != [len(g) for g in cg]:
        raise ValueError('brace groups do not line up: %s  ->  %s' % (keys, cmd))
    combos = itertools.product(*[range(len(g)) for g in kg])
    return [(substitute(keys, kg, p), substitute(cmd, cg, p)) for p in combos]


def pretty(keys):
    parts = [p.strip() for p in keys.split(' + ')]
    return ' + '.join(NAMES.get(p, p.upper() if len(p) == 1 else p) for p in parts)


def rows(path=CONFIG):
    result = []
    for b in read_bindings(path):
        multi = bool(GROUP.search(b['keys']))
        for k, c in expand(b['keys'], b['cmd']):
            desc = b['desc'] or c
            if multi:   # one description covers several keys, so show which command each key runs
                desc = '%s   [%s]' % (desc, c if len(c) <= 48 else c[:45] + '...')
            result.append(dict(section=b['section'], desc=desc, keys=k, cmd=c, shown=pretty(k)))
    return result


def main(argv):
    if not argv or argv[0] not in ('--rows', '--cmd', '--keys', '--markdown', '--check'):
        print(__doc__)
        return 2
    data = rows()
    mode = argv[0]
    if mode == '--rows':
        for r in data:
            print('%-13s %-32s %s' % (r['section'], r['shown'], r['desc']))
    elif mode in ('--cmd', '--keys'):
        n = int(argv[1])
        r = data[n]
        if mode == '--keys':
            print(r['shown'])
        else:
            print('' if UNSAFE.search(r['cmd']) else r['cmd'])
    elif mode == '--markdown':
        current = None
        for r in data:
            if r['section'] != current:
                current = r['section']
                print('\n## %s\n\n| Keys | Action |\n|---|---|' % current)
            print('| `%s` | %s |' % (r['shown'], r['desc'].replace('|', '\\|')))
    elif mode == '--check':
        problems, seen = [], {}
        for r in data:
            if '{' in r['keys'] or '}' in r['keys'] or '{' in r['cmd'] or '}' in r['cmd']:
                problems.append('unexpanded braces: %s' % r['shown'])
            key = r['keys']
            if key in seen and seen[key] != r['cmd']:
                problems.append('duplicate key %s (%s and %s)' % (r['shown'], seen[key], r['cmd']))
            seen.setdefault(key, r['cmd'])
        for p in problems:
            print('FAIL ' + p)
        print('%d bindings, %d problems' % (len(data), len(problems)))
        return 1 if problems else 0
    return 0


if __name__ == '__main__':
    try:
        sys.exit(main(sys.argv[1:]))
    except ValueError as err:
        print('FAIL ' + str(err))
        sys.exit(1)
