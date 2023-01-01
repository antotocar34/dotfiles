# This script downloads a magazine, adds it to the calibre library and 
# sends it to the kindle by email.
# 
KINDLE_EMAIL=antoinecarnec2_Hk8t1g@kindle.com
MAGAZINE_LIBRARY=${HOME}/Documents/Books/Calibre/Magazines
RECIPE_FILE=${HOME}/Documents/Storage/accessible/calibre/recipes/economist.recipe
EXTENSION=mobi

download_news () {
  cd "$(mktemp -d)"
  output_name="./economist_$(date "+%V_%Y").${EXTENSION}"
  ebook-convert "$RECIPE_FILE" "$output_name"
  calibredb --with-library="${MAGAZINE_LIBRARY}" add "$output_name"
  echo "Sending mail"
  echo | mutt -s "" -a "$output_name" -- "${KINDLE_EMAIL}" && echo "Emailing Successful!"
}

download_news
