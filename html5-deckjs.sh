#!/usr/bin/env bash

src=$(git rev-parse --show-toplevel) || {
    echo "Try running the script from within html5-deckjs directories." >&2
    exit 1
}
[[ -d $src ]] || {
    echo "Fatal: could not determine html5-deckjs's root directory." >&2
    echo "Try updating git." >&2
    exit 1
}

while [[ -z $name ]]
do
    echo "To create a new project, enter a new directory name:"
    read name || exit
done
dst=$src/../$name

if [[ -d $dst ]]
then
    echo "$dst exists!"
    exit 1
else
    mkdir $dst || exit 1

    echo "Copying files into your project..."

    cd -- "$src/libs/html5-boilerplate/"
    cp -vr -- css js img build test *.html *.xml *.txt *.png *.ico .htaccess "$dst"

    mkdir $dst/js/mylibs/deck.js || exit 1
    
    cd -- "$src/libs/deck.js/"
    cp -vr -- core extensions themes *.js *.txt "$dst/js/mylibs/deck.js/"
fi

echo "Generate your html file..."

cd -- $dst
TMPFILE=./index.html.tmp
if [[ -f $TMPFILE ]]
then
    rm -f $TMPFILE
fi

IFS=""
while read value
do
    style=$(echo $value | grep 'style.css' | wc -l)
    body=$(echo $value | grep 'id="container"' | wc -l)
    main=$(echo $value | grep 'role="main"' | wc -l)
    script=$(echo $value | grep '<script defer src="js/script.js"></script>' | wc -l)
    special=$(echo $value | grep "window.jQuery" | wc -l)
    if [[ $style -ne 0 ]]
    then
          echo '  <!-- compass default stylesheets -->
  <link href="css/screen.css" media="screen, projection" rel="stylesheet">
  <link href="css/print.css" media="print" rel="stylesheet">
  <!--[if IE]>
  <link href="css/ie.css" media="screen, projection" rel="stylesheet">
  <![endif]-->

  <!-- deck.js core/extensions stylesheets -->
  <link rel="stylesheet" href="js/mylibs/deck.js/core/deck.core.css"> 
  <link rel="stylesheet" href="js/mylibs/deck.js/extensions/goto/deck.goto.css">
  <link rel="stylesheet" href="js/mylibs/deck.js/extensions/menu/deck.menu.css"> 
  <link rel="stylesheet" href="js/mylibs/deck.js/extensions/navigation/deck.navigation.css"> 
  <link rel="stylesheet" href="js/mylibs/deck.js/extensions/status/deck.status.css"> 
  <link rel="stylesheet" href="js/mylibs/deck.js/extensions/hash/deck.hash.css">

  <!-- deck.js theme stylesheets -->
  <link rel="stylesheet" href="js/mylibs/deck.js/themes/transition/horizontal-slide.css">' >> $TMPFILE 

        echo -e $value >> $TMPFILE
    elif [[ $body -ne 0 ]]
    then
        echo '  <div id="container" class="presentation">' >> $TMPFILE
    elif [[ $main -ne 0 ]]
    then
        echo '    <div role="main" class="deck-container">
      <div class="slide" id="startup">
        <h1>Ready to go.</h1>
      </div>
      <div class="slide" id="fin">
        <h1>~fin.</h1>
      </div>

      <a href="#" class="deck-prev-link" title="Previous">&#8592;</a> 
      <a href="#" class="deck-next-link" title="Next">&#8594;</a> 

      <p class="deck-status"> 
      <span class="deck-status-current"></span> 
      /
      <span class="deck-status-total"></span> 
      </p> 

      <form action="." method="get" class="goto-form">
        <label for="goto-slide">Go to slide:</label>
        <input type="number" name="slidenum" id="goto-slide">
        <input type="submit" value="Go">
      </form>

      <a href="." title="Permalink to this slide" class="deck-permalink">#</a> 
' >> $TMPFILE
    elif [[ $script -ne 0 ]]
    then
        echo -e $value >> $TMPFILE
        echo '  <!-- Deck Core and extensions --> 
  <script src="js/mylibs/deck.js/core/deck.core.js"></script> 
  <script src="js/mylibs/deck.js/extensions/goto/deck.goto.js"></script> 
  <script src="js/mylibs/deck.js/extensions/status/deck.status.js"></script> 
  <script src="js/mylibs/deck.js/extensions/navigation/deck.navigation.js"></script> 
  <script src="js/mylibs/deck.js/extensions/hash/deck.hash.js"></script>' >> $TMPFILE
    elif [[ $special -ne 0 ]]
    then
        echo "  <script>window.jQuery || document.write('<script src=\"js/libs/jquery-1.6.3.min.js\"><\\/script>')</script>" >> $TMPFILE
    else
        echo -e $value >> $TMPFILE
    fi
done < ./index.html

mv ./index.html ./index.html.old
mv ./index.html.tmp ./index.html

echo "Install Compass..."

cd $src/../
compass create -x sass --css-dir css --image-dir img --javascripts-dir js -s compact --no-line-comments $name
cd $dst

cp $src/sample/sample.sass $dst/sass/style.sass
cp $src/sample/sample.css $dst/css/style.css
cp $src/sample/sample.js $dst/js/script.js

echo "Done."
