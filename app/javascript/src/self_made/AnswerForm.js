document.addEventListener("DOMContentLoaded", function(){
  if(document.querySelector('#questionImageDropdownButton')){
    // オフキャンバスがひれかれた時に問題文ドロップダウンが開いているときは、それを閉じる
    document.querySelector("#offcanvasHumberger").addEventListener("show.bs.offcanvas", function(){
      new bootstrap.Dropdown("#questionImageDropdownButton").hide();
    });
  }
  // ツールチップを許可
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl);
  });
});
