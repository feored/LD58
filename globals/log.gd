class_name Log

enum LogLevel {ERROR = 0, WARNING = 1, INFO = 2, DEBUG = 3}
const LOG_PREFIXES = {
    LogLevel.ERROR: "[ERROR]",
    LogLevel.WARNING: "[WARNING]",
    LogLevel.INFO: "[INFO]",
    LogLevel.DEBUG: "[DEBUG]"
}

static var log_level : LogLevel = LogLevel.DEBUG

static func timestamp() -> String:
    return Time.get_time_string_from_system(false)

static func _log(message: String, level: LogLevel):
    if log_level >= level:
        var log_message = "%s %s: %s" %[timestamp(), LOG_PREFIXES[level] ,message]
        if level == LogLevel.ERROR:
            push_error(log_message)
        elif level == LogLevel.WARNING:
            push_warning(log_message)
        else:
            print(log_message)

static func error(message : Variant,  ...args):
    _log(("%s" % message) + " ".join(args), LogLevel.ERROR)

static func warning(message : Variant, ...args):
    _log(("%s" % message) + " ".join(args), LogLevel.WARNING)

static func info(message : Variant, ...args):
    _log(("%s" % message) + " ".join(args), LogLevel.INFO)

static func debug(message : Variant, ...args):
    _log(("%s" % message) + " ".join(args), LogLevel.DEBUG)
