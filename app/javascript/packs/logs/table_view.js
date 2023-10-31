window.addEventListener('unload', (event) => {
  var scrollPos = $(document).scrollTop();
  localStorage.setItem('scrollPos', scrollPos);
  var scrolTLeft = $('.table-responsive').scrollLeft();
  localStorage.setItem('scrolTLeft', scrolTLeft);
});

window.addEventListener('load', (event) => {
  var pos = localStorage.getItem('scrollPos');
  $('html,body').scrollTop(pos);
  var tLeft = localStorage.getItem('scrolTLeft');
  dataRefresh();
  $('.table-responsive').scrollLeft(tLeft);
  localStorage.removeItem('scrolTLeft');
  localStorage.removeItem('scrollPos');
  setInterval(dataRefresh, 1000 * 15);
});

// popover排他クローズとインナーボタンクリック用
$('body').on('click', function (e) {
  $('[data-bs-toggle="popover"]').each(function () {
    //the 'is' for buttons that trigger popups
    //the 'has' for icons within a button that triggers a popup
    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
      $(this).popover('hide');
    }
  });
});

const updatePercent = (querySize, completions) => {
  const p = Math.floor(parseInt(completions / querySize * 10000) / 100);
  $('#sync-percent').text(`${p}%`);
}

const getHour = date_string => {
  const d = new Date(date_string)
  return d.getHours()
}

const minuteStr2Digits = date_string => {
  const d = new Date(date_string)
  return d.getMinutes().toString().padStart(2, '0');
}

const getDate = date_string => {
  const d = new Date(date_string)
  const formatted = `${d.getFullYear()}-${(d.getMonth() + 1).toString().padStart(2, '0')}-${d.getDate().toString().padStart(2, '0')}`.replace(/\n|\r/g, '');
  return formatted
}

const insertData = ($targetCel, l) => {
  let link = '';
  let m = minuteStr2Digits(l.date_time);
  switch (l.log_type) {
    case 1:
      m += ` ${l.milk_amount}`;
      break;
    case 3:
      const stool_colors = ['(1)', '(2)', '(3)', '(4)', '(5)', '(6)', '(7)']
      m += ` ${stool_colors[l.stool_color - 1]}`;
      if (l.stool_little) m += " <i class='fas fa-hand-lizard'></i>";
      break;
    case 4:
      m += ` ${l.body_temperature.toFixed(1)}`
      break;
    case 5:
      m += " <i class='fas fa-plus-circle'></i>"
      break;
  }
  if (l.log_type === 5) {
    const tags = l.tag_list.map(e => `<span class='text-success p-1'><i class='fas fa-tag'></i> ${e}</span>`);
    link = `<a class="text-decoration-none has-popover" role="button" data-desc-path="/logs/${l.id}/edit" data-bs-toggle="popover" data-bs-placement="left" data-bs-animation="false" data-bs-html="true" data-bs-content="${tags.join(' ')}<p>${l.description.split('\n').join('<br>')}</p><div class='d-grid gap-2'><a class='btn btn-primary btn-sm' href='/logs/${l.id}/edit'>編集</a></div>">${m}</a>`
  } else {
    link = `<a class="text-decoration-none" href="/logs/${l.id}/edit">${m}</a>`
  }
  link += '<br>';
  $targetCel.append($(link));
}

const setData = d => {
  if ($('.popover-body').length) {
    localStorage.setItem('popshow', $('.popover-body').find('a').attr('href'));
  } else {
    localStorage.removeItem('popshow');
  }
  $(".has-popover").popover('dispose');
  $('[data-log-ajax="true"]').children().remove();
  d.forEach(e => {
    const $targetCel = $(`[data-date="${getDate(e.date_time)}"][data-hour="${getHour(e.date_time)}"][data-type="${e.log_type}"]`)
    insertData($targetCel, e)
  });
}

const dataRefresh = () => {
  $('#syncing-info').show();
  const ajaxData = $('#data-for-ajax').data();
  $.ajax({
    url: ajaxData["baseUrl"],
    type: "GET",
    data: ajaxData,
    dataType: "json"
  }).done(data => {
    setData(data["logs"])
    $(".has-popover").popover('hide');
    document.querySelectorAll('.has-popover').forEach(function (element) {
      element.removeEventListener('show.bs.popover', function (e) {
        e.target.classList.add('link-danger');
        e.target.lastElementChild.classList.remove('fa-plus-circle');
        e.target.lastElementChild.classList.add('fa-minus-circle');
      })
      element.removeEventListener('hide.bs.popover', function (e) {
        e.target.classList.remove('link-danger');
        e.target.lastElementChild.classList.remove('fa-minus-circle');
        e.target.lastElementChild.classList.add('fa-plus-circle');
      })
      element.addEventListener('show.bs.popover', function (e) {
        e.target.classList.add('link-danger');
        e.target.lastElementChild.classList.remove('fa-plus-circle');
        e.target.lastElementChild.classList.add('fa-minus-circle');
      })
      element.addEventListener('hide.bs.popover', function (e) {
        e.target.classList.remove('link-danger');
        e.target.lastElementChild.classList.remove('fa-minus-circle');
        e.target.lastElementChild.classList.add('fa-plus-circle');
      })

      var popShow = localStorage.getItem('popshow');
      if ($(element).data('descPath') === popShow) {
        $(element).popover('show');
      }
    });
    localStorage.removeItem('popshow');
  }).fail(err => {
    console.log(err);
  }).always(res => {
    $('#syncing-info').hide();
  });
}

document.addEventListener('DOMContentLoaded', function() {
  var toggleButton = document.getElementById('display-ago-toggle');
  toggleButton.addEventListener('click', function() {
    window.location.href = toggleButton.getAttribute('href')
  });
});