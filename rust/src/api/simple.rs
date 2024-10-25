use std::{thread::sleep, time::Duration};

use flutter_rust_bridge::frb;
use once_cell::sync::OnceCell;

use crate::frb_generated::StreamSink;

#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[frb(ignore)]
fn delegate(word: String, current: i32, max: i32) {
    MEM.get()
        .unwrap()
        .add(Progress { word, current, max })
        .unwrap();
}

static MEM: OnceCell<StreamSink<Progress>> = OnceCell::new();

pub struct Progress {
    pub current: i32,
    pub max: i32,
    pub word: String,
}

pub fn words_oncecell(sink: StreamSink<Progress>) {
    MEM.get_or_init(|| sink);
    inner_other(delegate);
}

pub fn words(sink: StreamSink<Progress>) {
    inner(|word, current, max| sink.add(Progress { word, current, max }).unwrap())
}

fn inner<T: Fn(String, i32, i32)>(callback: T) {
    callback("Hello".to_owned(), 1, 4);
    sleep(Duration::from_secs(3));
    callback("Peter".to_owned(), 2, 4);
    sleep(Duration::from_secs(1));
    callback("Hans".to_owned(), 3, 4);
    sleep(Duration::from_secs(2));
    callback("Robert".to_owned(), 4, 4);
}
fn inner_other(callback: fn(word: String, current: i32, max: i32)) {
    callback("Hello".to_owned(), 1, 4);
    sleep(Duration::from_secs(3));
    callback("Peter".to_owned(), 2, 4);
    sleep(Duration::from_secs(1));
    callback("Hans".to_owned(), 3, 4);
    sleep(Duration::from_secs(2));
    callback("Robert".to_owned(), 4, 4);
}
