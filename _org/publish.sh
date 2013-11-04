#!/bin/sh

TEMP='../_processing';
TOC='totalindex';

echo '---
layout: default
title: Index
---
<div id="table-of-contents2">
<h3>Index</h3>
<div id="text-table-of-contents2">
<ul>' > $TEMP/$TOC;

for FILE in *.org
do
  DATEI=$(echo $FILE | sed 's_\(.*\).org_\1_');
  URL=$(echo /$DATEI | sed 's_-_/_; s_-_/_; s_-_/_; s_$_.html_')
  TITLE=$(sed -n '2,/---/ s_title: *"*\([^"]*\)"*_\1_p' $DATEI.org);
  FATHER=$(sed -n '2,/---/ s_father: *"*\([^"]*\)"*_\1_p' $DATEI.org);
    
  test -e $TEMP/$DATEI.html &&
  echo '<li><a href="'$URL'">'$TITLE'</a>' >> categorie.$FATHER &&
  sed -n '/<div id="text-table-of-contents">/,/<\/div>/p' $TEMP/$DATEI.html | 
    tail -n +2 | 
    head -n -1 | 
    sed 's:\(href="\)#:\1'$URL'#:g' >> categorie.$FATHER &&
  sed -n '2,/---/ p' $DATEI.org > $TEMP/$DATEI.org.publish &&
  sed 'N;
    s_[(</ul>)(</dl>)]\n</div>_&<p></p>_;
    P;
    s_file:///_/_;
    s_<h2>Table of Contents</h2>_<h3>Inhaltsverzeichnis</h3>_;
    D' $TEMP/$DATEI.html >> $TEMP/$DATEI.org.publish &&
  cat $TEMP/$DATEI.org.publish > ../_posts/$DATEI.html;
done

mv categorie. categorie.zzz

for INDEX in categorie.*
do
  if [ "$(echo $INDEX | sed 's_categorie\.\(.*\)_\1_')" != 'zzz' ]
  then
    echo '<li><a href="">' $(echo $INDEX | 
      sed 's_categorie\.\(.*\)_\1_') '</a>' '<ul>' >> $TEMP/$TOC;
    else
      echo '<li><a href="">' Verschiedenes '</a>' '<ul>' >> $TEMP/$TOC
  fi
  cat $INDEX >> $TEMP/$TOC;
  echo '</ul>' >> $TEMP/$TOC;
done

echo '</ul></div></div>' >> $TEMP/$TOC;
cp $TEMP/$TOC  ../$TOC.html;
mv categorie.* $TEMP;
cp ../_posts/about.html ../about.html;
test -e *.org~ && rm *.org~ ;
