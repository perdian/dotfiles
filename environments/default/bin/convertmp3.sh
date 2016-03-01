for fileName in *
do
  if [ -f "$fileName" ] ; then
    ffmpeg -i "$fileName" -ab 128k "$fileName.mp3"
    echo "Finished converting $fileName"
  fi
done
