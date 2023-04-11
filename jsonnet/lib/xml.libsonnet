local newLine = '\n';
local tab = '    ';
local header = '<?xml version="1.0"?>' + newLine;

// Some utility functions for generating XML.
// https://jsonnet.org/articles/output-formats.html
{
  // Serialize a XML document represented as a
  // Jsonnet value.  Each node of the XML tree
  // has a field 'tag', and optionally 'attrs'
  // (an string mapping), and 'has', an array
  // of children.
  manifestXmlObj(value)::
    local aux(v, cindent) =
      if !std.isObject(v) then
        error 'Expected a object, got %s'
              % std.type(value)
      else
        local attrs = [
          ' %s="%s"' % [k, v.attrs[k]]
          for k in std.objectFields(v.attrs)
        ];
        if std.isString(v.has) && v.has != '' then
          std.deepJoin([
            cindent, '<', v.tag, attrs, '>',
            v.has,
            '</', v.tag, '>', newLine
          ])
        else if std.isArray(v.has) && std.length(v.has) > 0 then
          std.deepJoin([
            cindent, '<', v.tag, attrs, '>', newLine,
            [
              aux(x, cindent + tab)
              for x in v.has
            ],
            cindent, '</', v.tag, '>', newLine
          ])
        else
          std.deepJoin([cindent, '<', v.tag, attrs, ' />', newLine]);
    header + aux(value, ''),

  // A convenience object whose attributes are
  // taken from the top-level non-hidden fields
  // of the object.  This works except for
  // attributes called 'tag' or 'has'.
  Element(tag):: {
    local element = self,
    tag:: tag,
    attrs:: {
      [k]: element[k]
      for k in std.objectFields(element)
    },
    has:: [],
  },
  NewLine:: newLine,
  Tab:: tab,
}
