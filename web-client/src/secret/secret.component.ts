import { Component } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'secret-component',
  template: '<img src="{{imageSource}}"/>'
})
export class SecretComponent {

    public imageSource: String = "https://www.chula.ac.th/wp-content/uploads/2018/03/2018-03-08-Chulalongkorn-Uni-Selected-as-Southeast-Asian-Malacological-Society-Headquarters.jpg";

  constructor(
    private route: ActivatedRoute,
    private http: HttpClient,
  ) { }

  ngOnInit()  {
    this.route.params.forEach((params: Params) => {
        let secret = params['secret'];
        this.http.get(`http://localhost:3000/v2/secret/${secret}`).toPromise().then(
            value => {
                console.log(value);
                this.imageSource = value.toString();
            },
            rejectedReason => {
                this.imageSource = rejectedReason.error['text'];
            }
        )
    });
  }
}