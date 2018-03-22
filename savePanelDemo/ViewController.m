//
//  ViewController.m
//  savePanelDemo
//
//  Created by lichanglai on 2018/2/9.
//  Copyright © 2018年 lichanglai. All rights reserved.
//

#import "ViewController.h"

@interface TableRow : NSTableRowView
@end
@implementation TableRow
//绘制选中状态的背景
-(void)drawSelectionInRect:(NSRect)dirtyRect{
    NSRect selectionRect = NSInsetRect(self.bounds, 5.5, 5.5);
    [[NSColor colorWithCalibratedWhite:.72 alpha:1.0] setStroke];
    [[NSColor colorWithCalibratedWhite:.82 alpha:1.0] setFill];
    NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRoundedRect:selectionRect xRadius:10 yRadius:10];
    [selectionPath fill];
    [selectionPath stroke];
}
//绘制背景
-(void)drawBackgroundInRect:(NSRect)dirtyRect{
    [super drawBackgroundInRect:dirtyRect];
    [[NSColor greenColor]setFill];
    NSRectFill(dirtyRect);
}
@end

@interface ViewController()<NSTabViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) NSMutableArray *resources;
@property (nonatomic, strong) NSTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"rect:%@",NSStringFromRect(self.view.bounds));
    _resources = @[].mutableCopy;
    
    for (NSInteger i = 0; i < 100; i ++) {
        [_resources addObject:@(i)];
    }
    
    //创建按钮
    NSButton *selecteBtn = [NSButton buttonWithTitle:@"select" target:self action:@selector(selecteAction)];
    selecteBtn.frame = CGRectMake(0, 0, 100, 35);
    //按钮样式
    selecteBtn.bezelStyle = NSRoundedBezelStyle;
    //是否显示背景 默认YES
    selecteBtn.bordered = YES;
    //按钮的Type
    [selecteBtn setButtonType:NSButtonTypeMomentaryPushIn];
//    //设置图片
//    selecteBtn.image = [NSImage imageNamed:@"close.png"];
//    //按钮的标题
//    [selecteBtn setTitle:@"我是按钮"];
    //是否隐藏
    selecteBtn.hidden = NO;
    //设置按钮的tag
    selecteBtn.tag = 100;
    //标题居中显示
    selecteBtn.alignment = NSTextAlignmentCenter;
    //设置背景是否透明
    selecteBtn.transparent = NO;
    //按钮初始状态
    selecteBtn.state = NSOffState;
    //按钮是否高亮
    selecteBtn.highlighted = NO;
    //把当前按钮添加到视图上
    [self.view addSubview:selecteBtn];

    NSScrollView *tableContainerView = [[NSScrollView alloc] initWithFrame:CGRectMake(100, 64, self.view.bounds.size.width-200, self.view.bounds.size.height-64)];
    _tableView = [[NSTableView alloc] initWithFrame:CGRectMake(100, 64, self.view.bounds.size.width-200, self.view.bounds.size.height-64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
    [column1 setWidth:200];
    [_tableView addTableColumn:column1];//第一列
    NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:@"secondColumn"];
    [column2 setWidth:300];
    [_tableView addTableColumn:column2];//第二列
    [tableContainerView.contentView setDocumentView:_tableView];
    [self.view addSubview:tableContainerView];
    
    // Do any additional setup after loading the view.
}

//设置行数 通用
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _resources.count;
}
//绑定数据
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([tableColumn.identifier isEqualToString:@"firstColumn"]) {
        NSString *resource = [NSString stringWithFormat:@"%@",_resources[row]];
        return resource;
    }else if ([tableColumn.identifier isEqualToString:@"secondColumn"]) {
        return [NSString stringWithFormat:@"%@",_resources[row]];
    }
    return nil;
}
//用户编辑列表
- (void)tableView:(NSTableView *)tableView setObjectValue:(nullable id)object forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSLog(@"%@",object);
    _resources[row] = object;
}
//cell-base的cell展示前调用 可以进行自定制
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTextFieldCell * _cell = cell;
    _cell.textColor = [NSColor redColor];
}
//设置是否可以进行编辑
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    return YES;
}
//设置鼠标悬停在cell上显示的提示文本
- (NSString *)tableView:(NSTableView *)tableView toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation{
    return @"tip";
}
//当列表长度无法展示完整某行数据时 当鼠标悬停在此行上 是否扩展显示
- (BOOL)tableView:(NSTableView *)tableView shouldShowCellExpansionForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    return YES;
}
//设置cell的交互能力
/*
 如果返回YES，则Cell的交互能力会变强，例如NSButtonCell的点击将会调用- (void)tableView:(NSTableView *)tableView setObjectValue方法
 */
- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    return YES;
}
-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 30;
}
//排序回调函数
-(void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors{
    NSLog(@"%@",oldDescriptors[0]);
}


//设置某个元素的具体视图
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    //根据ID取视图
    NSTextField * view = [tableView makeViewWithIdentifier:@"cellId" owner:self];
    if (view==nil) {
        view = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        view.backgroundColor = [NSColor clearColor];
        view.identifier = @"cellId";
    }
    return view;
}
//设置每行容器视图
- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row{
    TableRow * rowView = [[TableRow alloc]init];
    return rowView;
}
//当添加行时调用的回调
- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row{
    NSLog(@"add");
}
//当移除行时调用的回调
- (void)tableView:(NSTableView *)tableView didRemoveRowView:(NSTableRowView *)rowView forRow:(NSInteger)row{
    NSLog(@"remove");
}
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    BOOL shouldSelectRow = YES;
    return shouldSelectRow;
}
// 鼠标左键按下响应事件函数
- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn {
    
}
// 鼠标左键按下响应事件函数
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    
}
///*
// 当用户通过键盘或鼠标将要选中某行时，返回设置要选中的行
// 如果实现了这个方法，上面一个方法将不会被调用
// */
//- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
//
//}


- (void)selecteAction {
    NSLog(@"click");
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
