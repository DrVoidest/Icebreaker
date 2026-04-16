#!/usr/bin/env python3
import sys
import json
import os


def parse_log(file_obj):
    files = []
    summary = {}
    in_summary = False

    for line in file_obj:
        line = line.strip()
        if not line:
            continue

        # Check if we have hit the summary section
        if "----------- SCAN SUMMARY -----------" in line:
            in_summary = True
            continue

        # Parse the data based on which section we are in
        if in_summary:
            if ":" in line:
                key, val = line.split(":", 1)
                summary[key.strip()] = val.strip()
        else:
            # Items before the summary go into the array
            if ":" in line:
                file_path, status = line.split(":", 1)
                files.append({"file": file_path.strip(), "status": status.strip()})
            else:
                files.append({"file": line, "status": ""})

    return {"problem_items": files, "summary": summary}


def main():
    # Check if a filename was provided as an argument
    if len(sys.argv) > 1:
        file_path = sys.argv[1]
        if not os.path.isfile(file_path):
            print(f"Error: File '{file_path}' not found.", file=sys.stderr)
            sys.exit(1)

        with open(file_path, "r", encoding="utf-8") as f:
            data = parse_log(f)
    else:
        # Fallback to reading from standard input (useful for piping)
        data = parse_log(sys.stdin)

    # Output the final JSON
    print(json.dumps(data, indent=2))


if __name__ == "__main__":
    main()
