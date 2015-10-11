Elm.Native.Extra = {}
Elm.Native.Extra.make = function(elm) {
	
	elm.Native = elm.Native || {};
	elm.Native.Extra = elm.Native.Extra || {};

	if (elm.Native.Extra.values)
	{
		return elm.Native.Extra.values;
	}

	var Json = Elm.Native.Json.make(elm);
	var Signal = Elm.Native.Signal.make(elm);

	function on(name, options, decoder, createMessage)
	{
		function eventHandler(event)
		{
			var value = A2(Json.runDecoderValue, decoder, event);
			if (value.ctor === 'Ok')
			{
				if (options.stopPropagation)
				{
					event.stopPropagation();
				}
				if (options.preventDefault)
				{
					event.preventDefault();
				}
				if(options.drag) {
					event.dataTransfer.setData("text", "");

					if(options.dragOption.image.src != "") {
						var img = document.createElement("img");
						var x = options.dragOption.image.x;
						var y  = options.dragOption.image.y;

						img.src = options.dragOption.image.src;
					
						event.dataTransfer.setDragImage(img, x, y);
					}
				}

				Signal.sendMessage(createMessage(value._0));
			}
		}
		return property('on' + name, eventHandler);
	}

	function property(key, value)	
	{
		return {
			key: key,
			value: value
		};	
	}


	Elm.Native.Extra.values = {
		on : F4(on)
	}

	return elm.Native.Extra.values = Elm.Native.Extra.values;
}
