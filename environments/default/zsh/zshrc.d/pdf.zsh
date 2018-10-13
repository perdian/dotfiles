# https://blog.omgmog.net/post/compressing-pdf-from-your-mac-or-linux-terminal-with-ghostscript/
# -dPDFSETTINGS=/screen   (screen-view-only quality, 72 dpi images)
# -dPDFSETTINGS=/ebook    (low quality, 150 dpi images)
# -dPDFSETTINGS=/printer  (high quality, 300 dpi images)
# -dPDFSETTINGS=/prepress (high quality, color preserving, 300 dpi imgs)
# -dPDFSETTINGS=/default  (almost identical to /screen)

pdfcompress() {
    gs -sDEVICE=pdfwrite -dNOPAUSE -dQUIET -dBATCH -dPDFSETTINGS=/${3:-"ebook"} -dCompatibilityLevel=1.5 -sOutputFile="$2" "$1"
}
