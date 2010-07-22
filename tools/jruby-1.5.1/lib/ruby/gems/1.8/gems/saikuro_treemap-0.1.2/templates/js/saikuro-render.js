function init(json){
  var tm = new $jit.TM.Squarified({
    injectInto: 'infovis',
    titleHeight: 15,
    animate: false,
    offset: 1,
    Events: {
      enable: true,
      onClick: function(node) {
        if(node) tm.enter(node);
      },
      onRightClick: function() {
        tm.out();
      }
    },
    duration: 1000,
    Tips: {
      enable: true,
      offsetX: 20,
      offsetY: 20,
      onShow: function(tip, node, isLeaf, domElement) {
        var html = "<b>Name:</b> " + node.id + "<br/>";
        var data = node.data;
        if(data.complexity) {
          html += "<b>Complexity:</b> " + data.complexity + "<br/>";
        }
        if(data.lines) {
          html += "<b>Lines:</b> " + data.lines + "<br/>";
        }
        tip.innerHTML = html;
      }  
    },
    onCreateLabel: function(domElement, node){
        domElement.innerHTML = node.name;
        var style = domElement.style;
        style.display = '';
        style.border = '1px solid transparent';
        domElement.onmouseover = function() {
          style.border = '1px solid #9FD4FF';
        };
        domElement.onmouseout = function() {
          style.border = '1px solid transparent';
        };
    }
  });
  tm.loadJSON(json);
  tm.refresh();
};
