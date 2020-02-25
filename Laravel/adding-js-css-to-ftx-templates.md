# Adding JS/CSS to Templates

#### 1. Move files to assets
- Put JS and CSS files into ```resources/assert/(js or css)/vendors```

#### 2. Code
- For JS: put the require and the code into ```window.onload = function()```
- For CSS: import the sheets used

#### 3. Compile assets
- Open Homestead SSH (top left of screen) 
- Type ```npm run dev``` or ```npm run hot``` (if doesn’t work, do ```npm install```, and try again) 