local xml = import 'xml.libsonnet';

{
  Container:: xml.Element('Container') {
    version: '2',

    simpleElement(name, value):: (
      self + {
        has +: [
          xml.Element(name) {
            has: value
          },
        ],
      }
    ),

    withName(value):: (
      self.simpleElement('Name', value)
    ),

    withRepository(value):: (
      self.simpleElement('Repository', value)
    ),

    withRegistry(value):: (
      self.simpleElement('Registry', value)
    ),

    withNetwork(value):: (
      self.simpleElement('Network', value)
    ),

    withNetworking(mode, ports):: (
      local portMappings = [
        xml.Element('Port') {
          has: [
            xml.Element('HostPort') {
              has: p.hostPort
            },
            xml.Element('ContainerPort') {
              has: p.containerPort
            },
            xml.Element('Protocol') {
              has: p.protocol
            },
          ],
        }
        for p in ports
      ];

      self + {
        has +: [
          xml.Element('Networking') {
            has: [
              xml.Element('Mode') {
                has: mode
              },
            ] + if std.length(portMappings) > 0 then [
              xml.Element('Publish') {
                has: portMappings
              },
            ] else [],
          },
        ],
      }
    ),

    withPrivileged(value):: (
      assert std.isBoolean(value);
      self.simpleElement('Privileged', if value then 'true' else 'false')
    ),

    withSupport(value):: (
      self.simpleElement('Support', value)
    ),

    withProject(value):: (
      self.simpleElement('Project', value)
    ),

    withOverview(value):: (
      self.simpleElement('Overview', value)
    ),

    withCategory(value):: (
      assert std.isArray(value);
      self.simpleElement('Category', std.join(' ', value))
    ),

    withIcon(value):: (
      local iconPath = 'https://raw.githubusercontent.com/markliederbach/unraid-templates/main/markliederbach/images';
      self.simpleElement('Icon', std.format('%s/%s.png', [iconPath, value]))
    ),

    withLogRotation():: (
      self.simpleElement('ExtraParams', '--log-opt max-size=50m --log-opt max-file=1')
    ),

    withPostArgs(value):: (
      self.simpleElement('PostArgs', value)
    ),

    withDescription(value):: (
      self.simpleElement('Description', value)
    ),

    withWebUI(port, path):: (
      self.simpleElement('WebUI', std.format('http://[IP]:[PORT:%s]%s', [port, path]))
    ),

    withConfigVariables(variables):: (
      assert std.isArray(variables) :
        std.format('[%s] Invalid variables (%s). Must be an array', [variables, std.type(variables)]);
      
      assert std.length(variables) > 0 :
        std.format('[%s] Invalid variables (%s). Must have at least one element', [variables, std.type(variables)]);

      std.foldl(
        function(prev, variable)
          prev.withConfig({
            type: 'Variable',
            name: variable.name,
            target: std.get(variable, 'target', variable.name),
            default: std.get(variable, 'default', ''),
            mode: '',
            description: variable.description,
            display: std.get(variable, 'display', 'always'),
            required: std.get(variable, 'required', false),
            mask: std.get(variable, 'mask', false),
          }),
        variables,
        self
      )
    ),

    withConfigPorts(ports):: (
      assert std.isArray(ports) :
        std.format('[%s] Invalid ports (%s). Must be an array', [ports, std.type(ports)]);
      
      assert std.length(ports) > 0 :
        std.format('[%s] Invalid ports (%s). Must have at least one element', [ports, std.type(ports)]);

      std.foldl(
        function(prev, port)
          prev.withConfig({
            type: 'Port',
            name: port.name,
            target: port.target,
            default: std.get(port, 'default', ''),
            mode: std.get(port, 'mode', 'tcp'),
            description: port.description,
            display: std.get(port, 'display', 'always'),
            required: std.get(port, 'required', false),
            mask: std.get(port, 'mask', false),
          }),
        ports,
        self
      )
    ),

    withConfigPaths(paths):: (
      assert std.isArray(paths) :
        std.format('[%s] Invalid paths (%s). Must be an array', [paths, std.type(paths)]);
      
      assert std.length(paths) > 0 :
        std.format('[%s] Invalid paths (%s). Must have at least one element', [paths, std.type(paths)]);

      std.foldl(
        function(prev, path)
          prev.withConfig({
            type: 'Path',
            name: path.name,
            target: path.target,
            default: std.get(path, 'default', ''),
            mode: std.get(path, 'mode', 'rw'),
            description: path.description,
            display: std.get(path, 'display', 'always'),
            required: std.get(path, 'required', false),
            mask: std.get(path, 'mask', false),
          }),
        paths,
        self
      )
    ),

    withConfig(config):: (
      assert std.isObject(config) :
        std.format('[%s] Invalid config (%s). Must be an object', [config, std.type(config)]);

      assert std.member(['Variable', 'Path', 'Port'], config.type) :
        std.format('[%s] Invalid config.type (%s). Must be one of Variable, Path, or Port', [config.name, config.type]);

      assert std.member(['always', 'advanced', 'hidden'], config.display) :
        std.format('[%s] Invalid config.display (%s). Must be one of always, advanced, or hidden', [config.name, config.display]);

      local modeOptions = 
        if config.type == 'Path' then ['rw', 'ro']
        else if config.type == 'Port' then ['tcp', 'udp']
        else [''];

      assert std.member(modeOptions, config.mode) :
        std.format('[%s] Invalid config.mode (%s). Must be one of %s', [config.name, config.mode, std.join(', ', modeOptions)]);

      assert std.isBoolean(config.required) :
        std.format('[%s] Invalid config.required type (%s). Must be a boolean', [config.name, std.type(config.required)]);

      assert std.isBoolean(config.mask) :
        std.format('[%s] Invalid config.mask type (%s). Must be a boolean', [config.name, std.type(config.mask)]);

      self + {
        has +: [
          xml.Element('Config') {
            Name: config.name,
            Target: config.target,
            Default: config.default,
            Mode: config.mode,
            Description: config.description,
            Type: config.type,
            Display: config.display,
            Required: if config.required then 'true' else 'false',
            Mask: if config.mask then 'true' else 'false',
          },
        ],
      }
    ),

    toXML():: (
      xml.manifestXmlObj(self)
    )
  },
}
