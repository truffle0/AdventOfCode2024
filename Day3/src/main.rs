use std::env;
use std::fs::File;
use std::io::{self, BufReader, Read, stdin};
use std::process::ExitCode;
use std::error::Error;
use regex::Regex;


fn part1(text: &str) -> Result<i64, Box<dyn Error>> {
    /* Yeah nah, the entire first part is just a regex */
    let re_mul = Regex::new(r"mul\((?<first>[0-9]+),(?<second>[0-9]+)\)")?;
    let bad_capture = || io::Error::new(io::ErrorKind::Other, "Part 1: Missing group from match!");
    
    let mut total = 0;
    for mul in re_mul.captures_iter(text) {
        let a:i64 = mul.name("first").ok_or(bad_capture())?.as_str().parse()?;
        let b:i64 = mul.name("second").ok_or(bad_capture())?.as_str().parse()?;

        // find next 'mul' -> extract ints -> multiply & add to total -> repeat
        total += a * b;
    }

    Ok(total)
}

fn part2(text: &str) -> Result<i64, Box<dyn Error>> {
    // Everything can be solved with a slightly more complicated regex
    let rx_do_or_mul = Regex::new(r"(?<switch>(?:don\'t|do)\(\))|mul\((?<first>[0-9]+),(?<second>[0-9]+)\)")?;
    let bad_capture = |x| io::Error::new(io::ErrorKind::Other, format!("Part 2: {}", x));

    let mut total = 0;
    let mut switch = true;
    for mat in rx_do_or_mul.captures_iter(text) {
        match mat.name("switch") {
            Some(x) => {
                match x.as_str() {
                    "do()" => switch = true,
                    "don't()" => switch = false,
                    x => return Err(Box::new(bad_capture(format!("Bad switch: {}", x).as_str()))),
                }
            },
            None => {
                if switch {
                    let a:i64 = mat.name("first").ok_or(bad_capture("Bad a capture!"))?.as_str().parse()?;
                    let b:i64 = mat.name("second").ok_or(bad_capture("Bad b capture!"))?.as_str().parse()?;

                    total += a * b;
                }
            }
        }
    }

    Ok(total)
}

fn main() -> Result<ExitCode, Box<dyn Error>> {
    let args:Vec<String> = env::args().collect();
    
    let mut reader: BufReader<Box<dyn Read>> = if args.len() > 1 {
        let source = File::open(args[1].as_str())?;
        BufReader::new(Box::new(source))
    } else {
        BufReader::new(Box::new(stdin()))
    };

    let mut code = String::new();
    reader.read_to_string(&mut code)?;

    println!("Part 1: {}", part1(&code)?.to_string());
    println!("Part 2: {}", part2(&code)?.to_string());

    return Ok(ExitCode::from(0));
}