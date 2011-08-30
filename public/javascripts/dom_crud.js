window.actions_list = []
function add_cmd_to_list(event){
  var cmds = JSON.parse(event.data)
  //window.actions_list.push(cmd)
  for (i in cmds){
    cmd = cmds[i]
    action_single_cmd(cmd)
  }
  
}


function action_single_cmd(cmd){
  if (cmd.method == 'add_element'){
    $(cmd.selector).append(
        ['<',cmd.element_type,' id="',cmd.id,'"></',cmd.element_type
        ,'>'
        ].join(''))
  }

  if (cmd.method == 'append'){
    $(cmd.selector).append(cmd.content)
  }

  if (cmd.method == 'prepend'){
    $(cmd.selector).prepend(cmd.content)
  }

  if (cmd.method == 'empty'){
    $(cmd.selector).empty()
  }


  if (cmd.method == 'set_inner_html' ){
    $(cmd.selector).text(cmd.text)
  }
  if (cmd.method == 'set_css' ){
    $(cmd.selector).css( cmd.property,cmd.value )
  }

  if (cmd.method == 'add_class' ){
    $(cmd.selector).addClass(cmd.value )
  }

  if (cmd.method == 'alert' ){
    alert(cmd.message)
  }
  if (cmd.method == 'add_onclick' ){
    $(cmd.selector).click(function(){
      ws.send("click,"+cmd.selector)
    })
  }
  if (cmd.method == 'add_onkeypress' ){
    $(cmd.selector).keypress(function(e){
      ws.send("keypress,"+cmd.selector+","+e.which)
    })
  }
  if (cmd.method == 'get_value' ){
    var val = $(cmd.selector).val()
    ws.send("value,"+cmd.selector+","+val)
  }
  if (cmd.method == 'set_value' ){
    $(cmd.selector).val(cmd.value)
  }
  if (cmd.method == 'remove_element' ){
    //$(cmd.selector).fadeOut(function(){
      $(cmd.selector).remove()
    //})
  }
  if (cmd.method == 'get_screen_size' ){
    ws.send("screen_size,"+ window.innerWidth+','+window.innerHeight)
  }
  if (cmd.method == 'make_draggable' ){
    $(cmd.selector).draggable({handle: cmd.handle_selector})
  }
 if (cmd.method == 'show_element' ){
    //$(cmd.selector).fadeIn()
    $(cmd.selector).show()
  }
}


//function event_parser(event){
//  var i;
//  for(i = 0; i < 10000; i++){
//    var cmd = window.actions_list.shift();
//    if (cmd == undefined){ return }
//    action_single_cmd(cmd)
//  }
//}

//setInterval('event_parser()',0)
