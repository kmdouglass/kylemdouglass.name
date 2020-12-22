#!/usr/bin/env sh

set -o errexit
set -o nounset

BUCKET_ADDRESS=s3://kylemdouglass.name

show_help() {
    echo "usage: $(basename "$0") build_dir"
    echo ""
    echo "  build_dir - The directory containing the build artifacts"
}

while :; do
    case $1 in
	-h|-\?|--help)
            show_help
            exit
            ;;
	*)
            break
    esac

    shift
done

BUILD_DIR=$1

aws s3 sync "$BUILD_DIR" "$BUCKET_ADDRESS" --delete
