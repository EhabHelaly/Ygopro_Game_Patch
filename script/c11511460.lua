--SW Ambush
function c11511460.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11511460.tg)
	e1:SetOperation(c11511460.op)
	c:RegisterEffect(e1)
end
function c11511460.filter(c,e,tp)
	return c:IsSetCard(0xffb) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11511460.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c11511460.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c11511460.op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11511460.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	ft=ft-1;
	if g:GetCount()>0 then
		local g2=Duel.GetMatchingGroup(c11511460.filter,tp,LOCATION_HAND,0,nil,e,tp)
		g2:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
		while g2:GetCount()>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(11511460,0))do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g3=g2:Select(tp,1,1,nil)
			if g3:GetCount()>0 then 
				g:Merge(g3)
				g2:Remove(Card.IsCode,nil,g3:GetFirst():GetCode())
				ft=ft-1;
			else
				g2:Clear()
			end
		end
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(11511460,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(c11511460.retcon)
		e1:SetOperation(c11511460.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c11511460.retfilter(c,fid)
	return c:GetFlagEffectLabel(11511460)==fid
end
function c11511460.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c11511460.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c11511460.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c11511460.retfilter,nil,e:GetLabel())
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
