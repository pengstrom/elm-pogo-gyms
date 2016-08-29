// pull in desired CSS/SASS files
require( './styles/main.scss' );

require( './fonts/pdfprint-react.css' );
require( './fonts/animation.css' );

// inject bundled Elm app into div#main
var Elm = require( './Main' );
// Elm.Main.embed( document.getElementById( 'main' ) );
Elm.Main.fullscreen();
