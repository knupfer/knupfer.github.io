#!/bin/sh

echo '---
layout: default
title: Index
---
<div id="table-of-contents2">
<h3>Index</h3>
<div id="text-table-of-contents2">
<ul>' > ../_processing/totalindex;

for FILE in *.org
do
    if [ $FILE != 'publish.org' ]
    then
        DATEI=$(echo $FILE | sed 's_\(.*\).org_\1_');
        URL=$(echo /$DATEI | sed 's_-_/_; s_-_/_; s_-_/_; s_$_.html_')
        TITLE=$(sed -n '2,/---/ s_title: *"*\([^"]*\)"*_\1_p' $DATEI.org);
        FATHER=$(sed -n '2,/---/ s_father: *"*\([^"]*\)"*_\1_p' $DATEI.org);
        
        test -e ../_processing/$DATEI.html &&
        
        echo '<li><a href="'$URL'">'$TITLE'</a>' >> categorie.$FATHER &&
        sed -n '/<div id="text-table-of-contents">/,/<\/div>/ p' ../_processing/$DATEI.html | 
            tail -n +2 | 
            head -n -1 | 
        sed 's:\(href="\)#:\1'$URL'#:g' >> categorie.$FATHER &&
        sed -n '2,/---/ p' $DATEI.org > ../_processing/$DATEI.org.publish &&
        sed 'N;
            s_[(</ul>)(</dl>)]\n</div>_&<p></p>_;
            P;
            s_file:///_/_;
            s_<h2>Table of Contents</h2>_<h3>Inhaltsverzeichnis</h3>_;
            D' ../_processing/$DATEI.html >> ../_processing/$DATEI.org.publish &&
        cat ../_processing/$DATEI.org.publish > ../_posts/$DATEI.html;
    fi
done

mv categorie. categorie.ZZZ

for INDEX in categorie.*
do
    if [ "$(echo $INDEX | sed 's_categorie\.\(.*\)_\1_')" != 'ZZZ' ]
    then
        echo '<li><a href="">' $(echo $INDEX | 
            sed 's_categorie\.\(.*\)_\1_') '</a>' '<ul>' >> ../_processing/totalindex;
    else
        echo '<li><a href="">' Verschiedenes '</a>' '<ul>' >> ../_processing/totalindex;
    fi
    cat $INDEX >> ../_processing/totalindex;
    echo '</ul>' >> ../_processing/totalindex;
done

echo '</ul></div></div>' >> ../_processing/totalindex;
cp ../_processing/totalindex  ../totalindex.html;
mv categorie.* ../_processing/;
cp ../_posts/about.html ../about.html;
rm *.org~
