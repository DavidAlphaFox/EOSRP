import {Component, ViewChild} from '@angular/core';
import {TextFilterComponent} from 'ng2-search-table/components/table-filter/text-filter.component';
import {SortableHeaderComponent} from 'ng2-search-table/components/header/sortable-header.component';
import {SelectFilterComponent} from "ng2-search-table/ng2-search-table";
import {SimpleHeaderComponent} from 'ng2-search-table/components/header/simple-header.component';
import {SearchTableComponent} from 'ng2-search-table/components/search-table.component';
import {SrpRequestForm} from '../models/srp-request-form';
import {SrpRequestService} from './srp-request.service';
import {ToastsManager} from 'ng2-toastr';

@Component({
  selector: 'srp-request',
  templateUrl: './srp-request.template.html'
})

export class SrpRequestComponent {
  @ViewChild('searchTable') searchTable: any
  srpRequestForm: SrpRequestForm;

  constructor(
    private srpRequestService: SrpRequestService,
    private toastr: ToastsManager
  ) {
    this.srpRequestForm = new SrpRequestForm();
  }

  searchTableConfig: any = {
    url: process.env.API_URL + '/api/srp_requests',
    defaultPagePer: 20
  };

  headerComponents: any = [
    {
      name: 'id',
      model: { displayName: '#' },
      headerComponent: SortableHeaderComponent,
      filterComponent: TextFilterComponent
    },
    {
      name: 'processing_status',
      model: {
        displayName: "Status",
        selectValues: [
          { },
          { id: "in_process", name: "in_process" },
          { id: "done", name: "done" },
          { id: "reject", name: "reject" }
        ]
      },
      headerComponent: SortableHeaderComponent,
      filterComponent: SelectFilterComponent
    },
    {
      name: 'srp_destination',
      model: { displayName: '申請先' },
      headerComponent: SimpleHeaderComponent
    },
    {
      name: 'ship_ship_name',
      model: { displayName: 'ShipName' },
      headerComponent: SortableHeaderComponent,
      filterComponent: TextFilterComponent
    },
    {
      name: 'zkill_valuation',
      model: { displayName: '評価額' },
      headerComponent: SimpleHeaderComponent
    },
    {
      name: 'created_at',
      model: { displayName: 'CreatedAt' },
      headerComponent: SortableHeaderComponent
    },
    {
      name: 'updated_at',
      model: { displayName: 'UpdatedAt' },
      headerComponent: SortableHeaderComponent
    }
  ]

  reloadSearchTable() {
    if (this.searchTable) {
      // configの伝搬に時間がかかり別URLがリロードされるため、configを明示的に指定し直す
      // ng2-search-table 側にURLを変更するメソッドを取り入れたら、以下は削除する
      this.searchTable.config = this.searchTableConfig;
      this.searchTable.search();
    }
  }

  setCurrentPage(event: any): void {
    this.searchTable.setCurrentPage(event.page);
  }

  // Order Grid押下時
  selectRow(id: any, searchTable: any): void{
    var results = searchTable;
    for (let v of results.dataRows){
      v.selected = false;
      if (v.id == id){
        v.selected = !v.selected;
      }
    };
    this.loadDetail(id);
  }

  // 詳細選択時
  loadDetail(id){
    this.srpRequestService
    .get(id)
    .subscribe(
      r => {
        this.srpRequestForm = r;
      },
      error => {
        this.toastr.error("情報取得に失敗しました", "Error");
      }
    );
  }

  // 削除ボタン
  deleteSrpRequest(id, searchTable: any){
    this.srpRequestService
    .destroy(id)
    .subscribe(
      r => {
        this.toastr.success("削除しました", "Success");
        this.srpRequestForm = new SrpRequestForm();
        searchTable.search();
      },
      error => {
        if (error.status == 409){
          this.toastr.error("承認済みのため削除できません", "Error");
        }
        else{
          this.toastr.error("エラーが発生しました", "Error");
        }
      }
    )

  }

}
