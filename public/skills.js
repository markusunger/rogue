window.onload = () => {
  let button = document.getElementById('back-to-game');
  button.addEventListener("click", () => {
    window.location.href = '/'
  });

  let skill_rows = document.getElementsByTagName('tr');
  skill_rows = Array.prototype.slice.call(skill_rows);

  // all elements with equipped class (the 'o' marker) minus the one demo example
  let equipped = Array.prototype.slice.call(document.getElementsByClassName('equipped')).length - 1;
  console.log(equipped);

  skill_rows.forEach(row => {
    row.addEventListener("click", () => {
      let skillname = row.dataset.skillname;
      if (row.dataset.equipped == 'true') {
        window.location.href = '/removeskill/' + skillname;
      } else if (row.dataset.equipped == 'false' && equipped < 5) {
        window.location.href = '/addskill/' + skillname;
      }
    })
  })
}