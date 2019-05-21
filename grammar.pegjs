{
    const types = { };
    function exists(title) {
    	if (types[title] === true) return title;
        else return error("type " + title + " not found");
    }
    function register(type) {
    	types[type.name] = true;
        return type;
    }
    function format(types, compact, exportt) {
    	const iface = exportt ? 'export interface ' : 'interface ';
    	if (compact) {
        	return types.map(t => iface + t.name +  ' { ' + '' + t.fields.join('; ') + ' }').join('\n');
        }
        else {
        	return types.map(t => iface + t.name +  ' {\n' + '' + t.fields.map(f => '\t' + f).join('\n') + '\n}').join('\n');
        }
    }
}

Start = types:Types { return format(types, true, false) }

Types 
	= head:Type [ \r\n]+ tail:Types { return [head, ...tail] }
    / head:Type { return [head] }
Type = "type" _ name:Name _ "=" _ "{" _ fields:Fields _ "}" { return register({name, fields}) }

Fields "fields"
	= head:Field _ ";" _ tail:Fields { return [head, ...tail] }
    / head:Field { return [head] }
Field "field" 
	= name:Name _ ":"_ type:FSharpType _ "option" { return name + '?:' + type }
	/ name:Name _ ":"_ type:FSharpType { return name + ':' + type }

FSharpType "F# type" = FSharpArray / FSharpPrimitive
FSharpPrimitive = FSharpString / FSharpNumber / FSharpUserDefinedType
FSharpString = ("string" / "char") { return "string" }
FSharpNumber = ("int32" / "int64" / "int" / "float32" / "float64" / "float" / "decimal") { return "number" }
FSharpArray = type:FSharpPrimitive _ ("array" / "list" / "[]") { return type + '[]' }
FSharpUserDefinedType = title:Name { return exists(title) }

Name "name" = [^ \t\r\n:;]+ { return text() }
_ "whitespace" = [ ]*
