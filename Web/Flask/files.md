# Files

### Receiving file from user
```python
@app.route("/", methods=["GET", "POST"])
def upload_file():
    if request.method == "POST":
        if "file" not in request.files:
            flash("No file part")
            return redirect(request.url)

        file = request.files["file"]

        if file.filename == "":
            flash("No selected file")
            return redirect(request.url)

        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))

            return redirect(url_for("upload_file", filename=filename))

    return render_template("upload_pdf.html")
```
```html
<form method="POST" enctype=multipart/form-data>
  <input type=file name=file>
  <input type=submit value=Upload>
</form>
```