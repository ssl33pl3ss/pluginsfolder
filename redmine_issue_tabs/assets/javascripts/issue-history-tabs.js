RMPlus.TABS = (function (my) {
  var my = my || {};
  my.http_tab = 'history';
  my.has_ajax_tabs = false;

  my.add_new_tab = function(id, url, tab_header, tab_content, after) {
    var header_content = '<li>';
    header_content += '<a href="' + url + '?tab=' + id + '" id="tab-' + id + '" onclick="showTab(\'' + id + '\', this.href); this.blur(); return false;" class="no_line in_link" data-remote="true"><span>' + tab_header + '</span></a>';
    header_content += '</li>';
    if ($('#history_tabs').find('.tabs').length == 0) {
      $('#history_tabs').append('<div class="tabs"><ul></ul></div>');
    }

    if (after) {
      if ($(after).length > 0) {
        $(after).closest('li').after(header_content);
      } else {
        $('#history_tabs > .tabs > ul:first').prepend(header_content);
      }
    } else {
      $('#history_tabs > .tabs > ul:first').append(header_content);
    }

    $('#history_tabs').append('<div class="tab-content" id="tab-content-' + id + '" style="display:none">' + (tab_content || tab_content == '' ? tab_content : '<div class="big_loader form_loader"></div>') + '</div>');
    my.has_ajax_tabs = true;
    if (!tab_content && tab_content != '') {
      var link = $('#tab-' + id);
      link.click(function(event) {
        if ($('#tab-content-' + id).attr('data-loaded')) {
          $(this).removeAttr('data-remote');
          return;
        }
        $('#tab-content-' + id).attr('data-loaded', 1);
      });
    }
  };

  return my;
})(RMPlus.TABS || {});

$(document).ready(function () {
  var has_timelog = ($('#issue_timelog').length > 0);
  var has_changesets = ($('#issue-changesets').length > 0);

  if (has_timelog) {
    $('#issue_timelog').appendTo('#tab-content-timelog');
  } else {
    $('#tab-timelog').closest('li').remove();
    $('#tab-content-timelog').remove();
  }


  if(RMPlus.TABS.http_tab == '') {
    $('#tab-content-history').show();
  } else {
    $('#tab-content-' + RMPlus.TABS.http_tab).show();
  }

  if (has_changesets) {
    $('#issue-changesets').appendTo('#tab-content-changesets');
  } else {
    $('#tab-changesets').closest('li').remove();
    $('#tab-content-changesets').remove();
  }

  $('#history_tabs').insertAfter('div.issue:first');

  if ($('#history_tabs').find('.tabs ul li').length == 0) {
    $('#history_tabs').find('.tabs').remove();
  }

  if ($('#history_tabs .tabs a.selected').length == 0){
    $('#history_tabs .tabs a').trigger('click');
  }

  $('#history_tabs .tabs-buttons').remove();

});