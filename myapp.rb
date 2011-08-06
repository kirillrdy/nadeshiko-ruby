class MyApp < WebApp
  def setup_app
    add_element 'div','div1','main'
    set_inner_html 'div1','Hello'
    set_css 'div1','border','1px solid black'
    set_css 'div1','width','200px'
  end
end
