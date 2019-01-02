window.onload = () => {
  player_td = document.querySelector("[data-player='true']");
  let [x, y] = player_td.dataset.pos.split(',');
  x = parseInt(x);
  y = parseInt(y);
  // player_td.classList.add('light_normal_0');

  window.addEventListener("keyup", event => {
  let new_pos = '0,0';
  let skill_choice = 0;
  let skill_reset = false;
  let skill_select = false;
 
  switch(event.key) {
    case 'w':
      new_pos = `${x},${y-1}`;
      break;
    case 'a':
      new_pos = `${x-1},${y}`;
      break;
    case 's':
      new_pos = `${x},${y+1}`;
      break;
    case 'd':
      new_pos = `${x+1},${y}`;
      break;
    case 'q':
      new_pos = `${x-1},${y-1}`;
      break;
    case 'e':
      new_pos = `${x+1},${y-1}`;
      break;
    case 'y':
      new_pos = `${x-1},${y+1}`;
      break;
    case 'c':
      new_pos = `${x+1},${y+1}`;
      break;
    case 'l':
      skill_select = true;
      break;
    case '1':
      skill_choice = 1;
      break;
    case '2':
      skill_choice = 2;
      break;
    case '3':
      skill_choice = 3;
      break;
    case '4':
      skill_choice = 4;
      break;
    case '5':
      skill_choice = 5;
      break;
    case 'Escape':
      skill_reset = true;
      break;
  }

  if (skill_reset) {
    window.location.href = '/skillreset';
  }

  if (skill_select) {
    window.location.href = '/skillselect'
  }

  if (new_pos !== '0,0') {
    window.location.href = '/act/' + new_pos;
  }
  if (skill_choice !== 0) {
    window.location.href = '/skill/' + skill_choice;
  }
  })
}