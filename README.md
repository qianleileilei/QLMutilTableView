<p align="center" >
<img src="https://github.com/qianleileilei/QLMutilTableView/blob/master/QLMutilTableView/QLMutilTableView/4840889-3ff0f067adef635c.gif" alt="QLMutilTableView" title="QLMutilTableView">
</p>


QLMutilTableView是一个适用于多表数据显示的自定义控件，应用场景类似于股票行情数据显示和其他需要类似交互的样式等

## 需要达到的效果:

- 左右滑动时，保证第一列固定不动，右侧的列表可以根据手势进行左右滑动；
- 上线滑动时，整个列表都进行上线滑动，保证列表滑动的流畅性；
- 如果需要 **了解更多**, 查看 [简书](https://www.jianshu.com/p/589fcc1d22b9)


### 使用代码举例

```objective-c

@property (nonatomic, strong) QLMutilTableView *mutilTableView; //申明控件

- (void)viewDidLoad {
   [super viewDidLoad];
   _mutilTableView = [[QLMutilTableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - NavigationBarHeight)];  //初始化
   _mutilTableView.mutilBackGroundColor = [UIColor whiteColor];
   _mutilTableView.mutilTitleBackGroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0];
   _mutilTableView.titleTextColor = [UIColor blackColor];
   _mutilTableView.titleTextFont = [UIFont systemFontOfSize:15];
   _mutilTableView.mutilRowHeight = 50;
   _mutilTableView.leftTableWidth = 90;
   _mutilTableView.rightColumnWidth = 90;
   _mutilTableView.leftTitleString = @"固定列";
   _mutilTableView.headList = [NSArray arrayWithObjects:@"第一列", @"第二列", @"第三列", @"第四列", @"第五列", @"第六列", @"第七列", @"第八列", @"第九列", @"第十列", nil];
   _mutilTableView.showArrow = YES;
   _mutilTableView.supportTitleClicked = YES;
   _mutilTableView.delegate = self;
   _mutilTableView.sortDelegate = self;
   _mutilTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
   
   [self.view addSubview:self.mutilTableView];  //添加视图
}

```
