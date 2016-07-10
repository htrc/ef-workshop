'''
Merge multiple notebooks into one.

author: Peter Organisciak
email:  organisciak@gmail.com
'''

import json
import argparse
import sys


def main():
    parser = argparse.ArgumentParser(description='Join iPython files')
    parser.add_argument('--output', '-o', type=argparse.FileType('w'),
                        default=sys.stdout, help="Output file.")
    parser.add_argument('files', type=str, nargs='+',
                        help='List of ipynb Notebooks in desired order.')
    args = parser.parse_args()

    combined = combine_scripts(args.files)
    args.output.write(json.dumps(combined, indent=1))


def combine_scripts(paths):
    with open(paths[0], 'r+') as fp:
        output = json.load(fp)
    for path in paths[1:]:
        with open(path) as fp:
            nextf = json.load(fp)
        output['cells'].extend(nextf['cells'])
    return output

if __name__ == "__main__":
    main()
