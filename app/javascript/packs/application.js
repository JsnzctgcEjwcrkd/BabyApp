// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
// Turbolinks.start()
ActiveStorage.start()

require('jquery')
import "bootstrap"
// 作成したファイルをwebpackerに読み込ませます。
import "../stylesheets/application"
import "../js/pop_over"
import '@fortawesome/fontawesome-free/js/all'

// app/javascript/images/フォルダー内の画像を
// webpackerに読み込ませます。
const images = require.context("../images", true)
const imagePath = name => images(name, true)

window.addEventListener('load', (event) => {
  $(".alert").slideDown();
  $(".alert").fadeTo(8000, 500).slideUp(500, function () {
    $(".alert").slideUp(500);
  });

  if(!$("#htmltag").hasClass("night")) {
    $("input#lighting-sw").prop("checked",true);
  }

  $("#lighting-sw").on("change", e => {
    $("#htmltag").toggleClass('night');
  })
});