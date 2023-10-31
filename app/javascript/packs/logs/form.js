$(window).on("load", e => {
  refreshDateTimeView();
});

const elem = document.getElementsByClassName('range');
const rangeValue = (elem, target) => {
  return (evt) => {
    target.innerHTML = elem.value;
  }
}
const insertValue = (elem, target) => target.innerHTML = elem.value;
for (let i = 0, max = elem.length; i < max; i++) {
  bar = elem[i].getElementsByTagName('input')[0];
  target = elem[i].getElementsByTagName('span')[0];
  bar.addEventListener('input', rangeValue(bar, target));
  insertValue(bar, target);
}

$('.5min-btn').on('click', (e) => {
  const e_target = $(e.currentTarget);
  elementFlash(e_target);
  const amount = (e_target.data("plusminus") === "plus") ? 5 : -5;
  const ldt1 = e_target.siblings('#log_date_time_1i').val();
  const ldt2 = e_target.siblings('#log_date_time_2i').val() - 1;
  const ldt3 = e_target.siblings('#log_date_time_3i').val();
  const ldt4 = e_target.siblings('#log_date_time_4i').val();
  const ldt5 = e_target.siblings('#log_date_time_5i').val();
  const d = new Date(ldt1, ldt2, ldt3, ldt4, ldt5)
  d.setMinutes(d.getMinutes() + amount);
  const ndt1 = d.getFullYear();
  const ndt2 = d.getMonth() + 1;
  const ndt3 = d.getDate();
  const ndt4 = ("0" + d.getHours()).slice(-2);
  const ndt5 = ("0" + d.getMinutes()).slice(-2);
  // 拡大表示のためeventを意図的に発生
  e_target.siblings('#log_date_time_1i').val(ndt1);
  e_target.siblings('#log_date_time_2i').val(ndt2);
  e_target.siblings('#log_date_time_3i').val(ndt3);
  e_target.siblings('#log_date_time_4i').val(ndt4);
  e_target.siblings('#log_date_time_5i').val(ndt5).trigger("change");
  if (ldt1 != ndt1) {
    elementFlash($('#log_date_time_1i'));
    elementFlash($("#big-date-time-y"));
  }
  if (ldt2 != ndt2 - 1) {
    elementFlash($('#log_date_time_2i'));
    elementFlash($("#big-date-time-m"));
  }
  if (ldt3 != ndt3) {
    elementFlash($('#log_date_time_3i'));
    elementFlash($("#big-date-time-d"));
  }
  if (ldt4 != ndt4) {
    elementFlash($('#log_date_time_4i'));
    elementFlash($("#big-date-time-h"));
  }
  if (ldt5 != ndt5) {
    elementFlash($('#log_date_time_5i'));
    elementFlash($("#big-date-time-min"));
  }
});

const elementFlash = $e => {
  $e.css({
    "background-color": '#0dcaf0',
    "border-radius": "0.25rem"
  });
  $e.delay(100).queue(() => $e.css({
    "background-color": '',
    "border-radius": ""
  }).dequeue());
}

//タグボタン
const splitComma = val => {
  return (val === '') ? '' : ', ';
}

const addReturn = tAreaVal => {
  var regex = /\n$/;
  return (tAreaVal === '' || regex.test(tAreaVal)) ? '' : '\n';
}

$('.add-tag-btn').on('click', e => {
  const currentVal = $(e.currentTarget).data("tagText");
  const val = $('textarea[name="log[tag_list]"]').val();
  $('textarea[name="log[tag_list]"]').val(val + splitComma(val) + currentVal)

  const tAreaVal = $('#log_description').val();
  switch (currentVal) {
    case "お白湯":
      $('#log_description').val(tAreaVal + addReturn(tAreaVal) + "ml");
      $('#log_description').focus();
      break;
    case "パパママ体温":
      $('#log_description').val(tAreaVal + addReturn(tAreaVal) + "パパ°C ママ°C");
      $('#log_description').focus();
      break;
    case "寝た":
    case "起きた":
      break;
    default:
      $('#log_description').focus();
      break;
  }
});

//時刻拡大表示
$("#log_date_time_1i, #log_date_time_2i, #log_date_time_3i, #log_date_time_4i, #log_date_time_5i").on('change', e => {
  refreshDateTimeView();
  elementFlash($(e.currentTarget));
  switch ($(e.currentTarget).attr('id')) {
    case "log_date_time_1i":
      elementFlash($("#big-date-time-y"));
      break;
    case "log_date_time_2i":
      elementFlash($("#big-date-time-m"));
      break;
    case "log_date_time_3i":
      elementFlash($("#big-date-time-d"));
      break;
    case "log_date_time_4i":
      elementFlash($("#big-date-time-h"));
      break;
    case "log_date_time_5i":
      elementFlash($("#big-date-time-min"));
      break;
    default:
      elementFlash($("#big-date-time-y"));
      elementFlash($("#big-date-time-m"));
      elementFlash($("#big-date-time-d"));
      elementFlash($("#big-date-time-h"));
      elementFlash($("#big-date-time-min"));
      break;
  }
});

const refreshDateTimeView = () => {
  const y = $('#log_date_time_1i').val();
  const m = $('#log_date_time_2i').val();
  const d = $('#log_date_time_3i').val();
  const h = $('#log_date_time_4i').val();
  const min = $('#log_date_time_5i').val();
  $("#big-date-time-y").html(y);
  $("#big-date-time-m").html(m);
  $("#big-date-time-d").html(d);
  $("#big-date-time-h").html(h);
  $("#big-date-time-min").html(min);
}