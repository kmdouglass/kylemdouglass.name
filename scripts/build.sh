#!/usr/bin/env sh

set -o errexit
set -o nounset

trap 'rm -f ${ARTICLES}' EXIT

ARTICLES=/tmp/articles.fifo
BUILD_DIR=build
SRC_DIR=src
TEMPLATES_DIR=templates

PANDOC_FROM=org
PANDOC_FROM_FILE_EXT=.org
PANDOC_OPTIONS=--standalone
PANDOC_TO=html
PANDOC_TO_FILE_EXT=.html

render_article() {
    INPUT_FILE=$1
    OUTPUT_FILE=$(echo "$BUILD_DIR/$(echo "$INPUT_FILE" | cut -d/ -f2-)" |
		  sed "s/$PANDOC_FROM_FILE_EXT/$PANDOC_TO_FILE_EXT/")

    echo "Building article file $OUTPUT_FILE from source file $INPUT_FILE"
    pandoc "$INPUT_FILE" \
	   --from="$PANDOC_FROM" \
	   --to="$PANDOC_TO" \
	   --output="$OUTPUT_FILE" \
	   "$PANDOC_OPTIONS"
}

render_article_links() {
    mkfifo "$ARTICLES"
    find "$BUILD_DIR" -type f -name "*.html" | sort -r > "$ARTICLES" &

    article_links=""
    while read -r line; do
	title=$(grep '<h1 class="title">' "$line" | cut -f2 -d\> | cut -f1 -d\<)
	date=$(grep '<p class="date">' "$line" | cut -f2 -d\> | cut -f1 -d\<)
	article_links="$article_links        <li><a href=\"$(basename "$line")\">$date - $title</a></li>\n"
    done < "$ARTICLES"
    echo "$article_links"
}

if [ -d "$BUILD_DIR" ]
then
    echo "Removing old build directory: $BUILD_DIR"
    rm -r $BUILD_DIR
fi

echo "Creating the build directory: $BUILD_DIR"
mkdir -p $BUILD_DIR

echo "Building articles"
find "$SRC_DIR" -type f -name "*$PANDOC_FROM_FILE_EXT" | while read -r line; do
    render_article "$line"
done

echo "Building index.html"
article_links=$(render_article_links)
awk -v article_links="$article_links" '{print} /<!-- ARTICLES -->/{print article_links}' "$TEMPLATES_DIR/index.html" > "$BUILD_DIR/index.html"

printf "\nDone!\n"
